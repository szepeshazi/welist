import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../juiced/juiced.dart';
import '../profile/user_info_widget.dart';
import '../view_list/view_list_widget.dart';
import '../workspace/workspace.dart';
import 'create_list_widget.dart';
import 'workspace_navigator.dart';

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<Workspace>(create: (_) => Workspace(context.read<Auth>())..initialize()),
      Provider<WorkspaceNavigator>(create: (_) => WorkspaceNavigator())
    ], child: WorkspaceNavigatorWidget());
  }
}

class WorkspaceNavigatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    return Observer(
        builder: (context) => Navigator(
                pages: [
                  MaterialPage(key: ValueKey("containerList"), name: "containerList", child: WorkspaceScaffoldWidget()),
                  if (_workspaceNavigator.showAddContainerWidget)
                    MaterialPage(
                        key: ValueKey("addContainer"), name: "addContainer", child: CreateListContainerWidget()),
                  if (_workspaceNavigator.selectedContainer != null)
                    MaterialPage(
                        key: ValueKey("containerDetails"),
                        name: "containerDetails",
                        child: ViewListWidget(container: _workspaceNavigator.selectedContainer))
                ],
                onPopPage: (route, result) {
                  if (!route.didPop(result)) {
                    return false;
                  }
                  if (route.settings.name == "addContainer") {
                    _workspaceNavigator.toggleAddContainerWidget(false);
                  }
                  if (route.settings.name == "containerDetails") {
                    _workspaceNavigator.toggleSelectedContainer(null);
                  }
                  return true;
                }));
  }
}

class WorkspaceScaffoldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    return Scaffold(
        appBar: AppBar(title: Text("My lists"), actions: [UserInfoWidget()]),
        body: ListContainersWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _workspaceNavigator.toggleAddContainerWidget(true);
            }));
  }
}

class ListContainersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    return Observer(
        builder: (context) => ListView.builder(
            padding: const EdgeInsets.only(left: 8),
            shrinkWrap: true,
            itemCount: workspace.containers?.length ?? 0,
            itemBuilder: (BuildContext context, index) =>
                ListContainerRowWidget(container: workspace.containers[index])));
  }
}

class ListContainerRowWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerRowWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    return ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Row(children: [
              Container(padding: EdgeInsets.only(right: 5.0), child: container.icon),
              Text(container.name),
              if ((container.itemCount ?? 0) > 0) Text(" (${container.itemCount})")
            ])),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                child: InkWell(
                  onTap: () {}, // TODO: show shares for container
                  child: Row(children: [Icon(Icons.people), Text("(1)")]),
                )),
          ],
        ),
        trailing: PopupMenuButton<ListContainerMenuItem>(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ListContainerMenuItem.delete,
                    child: Row(children: [
                      Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Delete ${container.name}")),
                      Icon(Icons.delete)
                    ]),
                  )
                ],
            onSelected: (ListContainerMenuItem selected) {
              switch (selected) {
                case ListContainerMenuItem.delete:
                  workspace.delete(container);
                  break;
              }
            }),
        onTap: () {
          _workspaceNavigator.toggleSelectedContainer(container);
        });
  }
}

enum ListContainerMenuItem { delete }
