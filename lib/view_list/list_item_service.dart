import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../auth/auth_service.dart';
import '../juiced/juiced.dart';
import '../juiced/juiced.juicer.dart' as j;
import '../shared/service_base.dart';

part 'list_item_service.g.dart';

class ListItemService = _ListItemService with _$ListItemService;

abstract class _ListItemService with Store {
  @observable
  List<ListItem> items = [];

  @observable
  bool multiEditMode = false;

  /// The host ListContainer for this specific list
  final ListContainer container;

  final FirebaseFirestore fs;

  final AuthService _authService;

  StreamSubscription<QuerySnapshot> listChangeListener;

  _ListItemService(this.container, this._authService) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to authentication changes
    listChangeListener = container.reference
        .collection(ListItem.collectionName)
        .notDeleted
        .snapshots()
        .listen((updates) => _updateViewList(updates));
  }

  Future<void> _updateViewList(QuerySnapshot updates) async {
    List<ListItem> _items = List.from(items);
    print("_updateViewList received items ${updates.docChanges.length}");
    if (updates.docChanges.isNotEmpty) {
      for (var change in updates.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            ListItem item = j.juicer.decode(change.doc.data(), (_) => ListItem()..reference = change.doc.reference);
            _items.add(item);
            break;
          case DocumentChangeType.modified:
            int index = items.indexWhere((ListItem item) => item.reference.path == change.doc.reference.path);
            _items[index] = j.juicer.decode(change.doc.data(), (_) => ListItem()..reference = change.doc.reference);
            break;
          case DocumentChangeType.removed:
            _items.removeWhere((item) => item.reference.path == change.doc.reference.path);
            break;
        }
      }
    }
    items = _items;
  }

  @action
  Future<void> add(ListItem item) async {
    // TODO: input sanity check, transaction
    item
      ..timeCompleted = null
      ..accessLog = AccessLog();
    dynamic encodedItem = j.juicer.encode(item);
    item.log(_authService.user.reference.id, encodedItem);
    encodedItem["accessLog"] = j.juicer.encode(item.accessLog);

    // pseudo increment to be included in access log
    // real increment operation will happen on FB, and changes will be pushed to the obj
    container.itemCount++;
    dynamic encodedContainer = j.juicer.encode(container);
    container.log(_authService.user.reference.id, encodedContainer);
    dynamic containerAccess = j.juicer.encode(container.accessLog);

    await fs.runTransaction((transaction) async {
      await container.reference.collection("items").add(j.juicer.encode(item));
      await container.reference.update({"itemCount": FieldValue.increment(1), "accessLog": containerAccess});
    });
  }

  @action
  Future<void> update(ListItem item) async {
    // TODO: input sanity check, transaction
    dynamic encodedItem = j.juicer.encode(item);
    item.log(_authService.user.reference.id, encodedItem);
    encodedItem["accessLog"] = j.juicer.encode(item.accessLog);
    await item.reference.set(encodedItem);
  }

  @action
  Future<void> delete(ListItem item) async {
    // TODO: input sanity check, transaction
    dynamic encodedItem = j.juicer.encode(item);
    item.log(_authService.user.reference.id, encodedItem, deleteEntity: true);
    dynamic encodedAccess = j.juicer.encode(item.accessLog);
    await fs.runTransaction((transaction) async {
      await item.reference.update({"accessLog": encodedAccess});
      await container.reference.update({"itemCount": FieldValue.increment(-1)});
    });
  }

  @action
  void setMultiEditMode(bool newValue) => multiEditMode = newValue;

  void cleanUp() {
    listChangeListener?.cancel();
  }
}