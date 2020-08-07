import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'we_list_item.g.dart';

class WeListItem = _WeListItem with _$WeListItem;

abstract class _WeListItem with Store {
  final String name;

  final DocumentReference reference;

  @observable
  int createdAt;

  @observable
  int completedAt;

  _WeListItem(this.name)
      : reference = null,
        createdAt = DateTime.now().millisecondsSinceEpoch;

  _WeListItem.fromMap(Map<String, dynamic> data, {this.reference})
      : assert(data['name'] != null),
        assert(data['createdAt'] != null),
        name = data['name'],
        createdAt = data['createdAt'],
        completedAt = data['completedAt'];

  _WeListItem.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);

  @computed
  bool get completed => completedAt != null;

  @computed
  String get stateName =>
      completed ? "Completed at ${DateTime.fromMillisecondsSinceEpoch(completedAt).toIso8601String()}" : "Open";

  @action
  void setState(bool state) => completedAt = state ? DateTime.now().millisecondsSinceEpoch : null;

  @override
  String toString() => "$name ($stateName)";
}
