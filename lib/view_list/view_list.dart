import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist/juiced/juiced.dart';

import '../juiced/juiced.juicer.dart' as j;

part 'view_list.g.dart';

class ViewList = _ViewList with _$ViewList;

abstract class _ViewList with Store {
  @observable
  List<ListItem> items = [];

  @observable
  bool multiEditMode = false;

  /// The host ListContainer for this specific list
  final ListContainer container;

  final FirebaseFirestore fs;

  StreamSubscription<QuerySnapshot> listChangeListener;

  _ViewList(this.container) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to authentication changes
    listChangeListener =
        fs.doc(container.reference.path).collection("items").snapshots().listen((updates) => _updateViewList(updates));
  }

  Future<void> _updateViewList(QuerySnapshot updates) async {
    List<ListItem> _items = List.from(items);
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
      ..timeCreated = DateTime.now().millisecondsSinceEpoch
      ..timeCompleted = null;
    await fs.doc(container.reference.path).collection("items").add(j.juicer.encode(item));
    await fs.doc(container.reference.path).update({"itemCount": FieldValue.increment(1)});
  }

  @action
  Future<void> delete(ListItem item) async {
    // TODO: input sanity check, transaction
    await item.reference.delete();
    await fs.doc(container.reference.path).update({"itemCount": FieldValue.increment(-1)});
  }

  @action
  void setMultiEditMode(bool newValue) => multiEditMode = newValue;

  void cleanUp() {
    listChangeListener?.cancel();
  }
}
