import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist/we_list_item/we_list_item.dart';

part 'we_list.g.dart';

class WeList = _WeList with _$WeList;

abstract class _WeList with Store {

  @observable
  ObservableList<WeListItem> items  = ObservableList.of([
    WeListItem("Tejföl"),
    WeListItem("Wasabi")
  ]);

  @action
  Future<void> load() async {
    Firestore.instance.collection('listItems').snapshots().listen((event) {
      items = ObservableList.of(event.documents.map((e) => WeListItem.fromSnapshot(e)));
    });
  }

  @action
  void add(WeListItem item) => items.add(item);

  @action
  void remove(WeListItem item) => items.remove(item);
}
