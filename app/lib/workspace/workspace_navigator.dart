import 'package:mobx/mobx.dart';

import 'package:welist_common/common.dart';

part 'workspace_navigator.g.dart';

class WorkspaceNavigator = _WorkspaceNavigator with _$WorkspaceNavigator;

abstract class _WorkspaceNavigator with Store {
  @observable
  bool showAddContainerWidget = false;

  @observable
  ListContainer selectedContainer;

  @observable
  ListContainer showSharesForContainer;

  @observable
  bool showNotifications = false;

  @action
  void toggleAddContainerWidget(bool show) => showAddContainerWidget = show;

  @action
  void toggleSelectedContainer(ListContainer selected) => selectedContainer = selected;

  @action
  void toggleSharesForContainer(ListContainer selected) => showSharesForContainer = selected;

  @action
  void toggleNotifications(bool newValue) => showNotifications = newValue;
}
