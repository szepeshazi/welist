import 'package:mobx/mobx.dart';

part 'list_item.g.dart';

class ListItem = _ListItem with _$ListItem;

abstract class _ListItem with Store {

  final String name;

  @observable
  int createdAt;

  @observable
  int completedAt;

  _ListItem(this.name) : createdAt = DateTime.now().millisecondsSinceEpoch;

  @computed
  bool get completed => completedAt == null;

  @computed
  String get stateName =>
      completed ? "Completed at ${DateTime.fromMillisecondsSinceEpoch(completedAt).toIso8601String()}" : "Open";

  @computed
  String get nameWithState => "$name ($stateName)";

  @action
  void setState(bool state) => completedAt = completed ? DateTime.now().millisecondsSinceEpoch : null;
}
