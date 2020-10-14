import 'package:mobx/mobx.dart';

import '../juiced/workspace/list_container.dart';

part 'workspace_navigator.g.dart';

class WorkspaceNavigator = _WorkspaceNavigator with _$WorkspaceNavigator;

abstract class _WorkspaceNavigator with Store {
  @observable
  bool showAddContainerWidget = false;

  @observable
  ListContainer selectedContainer;

  @action
  void toggleAddContainerWidget(bool show) => showAddContainerWidget = show;

  @action
  void toggleSelectedContainer(ListContainer selected) => selectedContainer = selected;
}
