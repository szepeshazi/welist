import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'we_list.g.dart';

class WeList = _WeList with _$WeList;

abstract class _WeList with Store {
  // @observable
  // ObservableList<WeListItem> items;
  //
  // @action
  // Future<void> load() async {
  //   FirebaseFirestore.instance.collection('listItems').snapshots().listen((event) {
  //     items = ObservableList.of(event.docs.map((e) => WeListItem.fromSnapshot(e)));
  //   });
  // }
  //
  // @action
  // void add(WeListItem item) {
  //   FirebaseFirestore.instance
  //       .collection('listItems')
  //       .add({"name": item.name, "createdAt": item.createdAt, "completedAt": null});
  // }
  //
  // @action
  // void remove(WeListItem item) {
  //   print("deleting document ${item.id}");
  //   FirebaseFirestore.instance.collection('listItems').doc(item.id).delete();
  // }
}
