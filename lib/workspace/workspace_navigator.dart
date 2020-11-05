import 'package:mobx/mobx.dart';

import '../juiced/workspace/list_container.dart';

part 'workspace_navigator.g.dart';

class WorkspaceNavigator = _WorkspaceNavigator with _$WorkspaceNavigator;

abstract class _WorkspaceNavigator with Store {
  @observable
  bool showAddContainerWidget = false;

  @observable
  ListContainer selectedContainer;

  @observable
  ListContainer showSharesForContainer;

  @action
  void toggleAddContainerWidget(bool show) => showAddContainerWidget = show;

  @action
  void toggleSelectedContainer(ListContainer selected) => selectedContainer = selected;

  @action
  void toggleSharesForContainer(ListContainer selected) => showSharesForContainer = selected;
}
