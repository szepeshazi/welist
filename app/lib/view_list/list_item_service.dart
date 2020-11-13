import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../auth/auth_service.dart';
import '../shared/service_base.dart';
import '../workspace/list_container_service.dart';

part 'list_item_service.g.dart';

class ListItemService = _ListItemService with _$ListItemService;

abstract class _ListItemService extends ServiceBase<ListItem> with Store {
  @observable
  List<ListItem> items = [];

  @observable
  bool multiEditMode = false;

  /// The host ListContainer for this specific list
  final ListContainer container;

  @override
  final FirebaseFirestore fs;

  final AuthService _authService;

  final ListContainerService containerService;

  StreamSubscription<QuerySnapshot> listChangeListener;

  _ListItemService(this.container, this._authService, this.containerService)
      : fs = FirebaseFirestore.instance;

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
            ListItem item = j.juicer.decode(change.doc.data(),
                (_) => ListItem()..reference = change.doc.reference);
            _items.add(item);
            break;
          case DocumentChangeType.modified:
            int index = items.indexWhere((ListItem item) =>
                item.reference.path == change.doc.reference.path);
            _items[index] = j.juicer.decode(change.doc.data(),
                (_) => ListItem()..reference = change.doc.reference);
            break;
          case DocumentChangeType.removed:
            _items.removeWhere(
                (item) => item.reference.path == change.doc.reference.path);
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

    // pseudo increment to be included in access log
    // real increment operation will happen on FB, and changes will be pushed to the obj
    container.itemCount++;
    await fs.runTransaction((transaction) async {
      await upsert(item, _authService.user.reference.id,
          parent: container.reference);
      await containerService.updateFields(
          container,
          _authService.user.reference.id,
          {"itemCount": FieldValue.increment(1)});
    });
  }

  @action
  Future<void> update(ListItem item) async {
    // TODO: input sanity check, transaction
    await upsert(item, _authService.user.reference.id);
  }

  @action
  Future<void> delete(ListItem item) async {
    // TODO: input sanity check, transaction
    container.itemCount--;
    await fs.runTransaction((transaction) async {
      await upsert(item, _authService.user.reference.id,
          action: AccessAction.delete);
      await containerService.updateFields(
          container,
          _authService.user.reference.id,
          {"itemCount": FieldValue.increment(-1)});
    });
  }

  @action
  void setMultiEditMode(bool newValue) => multiEditMode = newValue;

  void cleanUp() {
    listChangeListener?.cancel();
  }
}
