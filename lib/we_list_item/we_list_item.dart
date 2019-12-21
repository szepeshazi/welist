import 'package:mobx/mobx.dart';

part 'we_list_item.g.dart';

class WeListItem = _WeListItem with _$WeListItem;

abstract class _WeListItem with Store {

  final String name;

  @observable
  int createdAt;

  @observable
  int completedAt;

  _WeListItem(this.name) : createdAt = DateTime.now().millisecondsSinceEpoch;

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
