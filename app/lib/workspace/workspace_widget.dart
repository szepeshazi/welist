import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/common/common.dart';
import 'package:welist_common/common.dart';

import '../auth/auth_service.dart';
import '../notification/notification_widget.dart';
import '../profile/user_info_widget.dart';
import '../view_list/view_list_widget.dart';
import '../workspace/list_container_service.dart';
import 'create_list_widget.dart';
import 'shares/invite/invite_service.dart';
import 'shares/invite/invite_widget.dart';
import 'shares/list_container_shares_widget.dart';
import 'shares/shares_navigator.dart';
import 'workspace_navigator.dart';

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<ListContainerService>(create: (_) => ListContainerService(context.read<AuthService>())..initialize()),
      Provider<InviteService>(create: (_) => InviteService(context.read<AuthService>())..initialize()),
      Provider<WorkspaceNavigator>(create: (_) => WorkspaceNavigator()),
      Provider<SharesNavigator>(create: (_) => SharesNavigator())
    ], child: WorkspaceNavigatorWidget());
  }
}

class WorkspaceNavigatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    final SharesNavigator _sharesNavigator = Provider.of(context);
    return Observer(
        builder: (context) => Navigator(
            key: GlobalKey(debugLabel: "first"),
            pages: [
              MaterialPage(
                  key: ValueKey("containerList"),
                  name: "containerList",
                  child: WorkspaceScaffoldWidget(
                    body: ListContainersWidget(),
                  )),
              if (_workspaceNavigator.showNotifications)
                MaterialPage(key: ValueKey("notifications"), name: "notifications", child: NotificationWidget()),
              if (_workspaceNavigator.showAddContainerWidget)
                MaterialPage(
                    key: ValueKey("addContainer"),
                    name: "addContainer",
                    child: WorkspaceScaffoldWidget(body: CreateListContainerWidget())),
              if (_workspaceNavigator.selectedContainer != null)
                MaterialPage(
                    key: ValueKey("containerDetails"),
                    name: "containerDetails",
                    child: ViewListWidget(container: _workspaceNavigator.selectedContainer)),
              if (_workspaceNavigator.showSharesForContainer != null)
                MaterialPage(
                    key: ValueKey("containerShares"),
                    name: "containerShares",
                    child: ListContainerSharesWidget(container: _workspaceNavigator.showSharesForContainer)),
              if (_sharesNavigator.showAddAccessorForm)
                MaterialPage(
                    key: ValueKey("containerShares/add"),
                    name: "containerShares/add",
                    child: InviteWidget(container: _workspaceNavigator.showSharesForContainer))
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              print("WorkspaceNavigator widget, popping: ${route.settings.name}");
              switch (route.settings.name) {
                case "notifications":
                  _workspaceNavigator.toggleNotifications(false);
                  break;
                case "addContainer":
                  _workspaceNavigator.toggleAddContainerWidget(false);
                  break;
                case "containerDetails":
                  _workspaceNavigator.toggleSelectedContainer(null);
                  break;
                case "containerShares":
                  _workspaceNavigator.toggleSharesForContainer(null);
                  break;
                case "containerShares/add":
                  _sharesNavigator.toggleAddAccessorForm(false);
                  break;
              }
              return true;
            }));
  }
}

class WorkspaceScaffoldWidget extends StatelessWidget {
  final Widget body;

  const WorkspaceScaffoldWidget({Key key, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    return Scaffold(
        appBar: AppBar(title: Text("My lists"), actions: [UserInfoWidget()]),
        body: body,
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
    final ListContainerService workspace = Provider.of(context);
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
  final FirestoreEntity<ListContainer> container;

  const ListContainerRowWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListContainerService _workspace = Provider.of(context);
    final WorkspaceNavigator _workspaceNavigator = Provider.of(context);
    return ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Row(children: [
              Container(padding: EdgeInsets.only(right: 5.0), child: icon),
              Text(container.entity.name),
              if ((container.entity.itemCount ?? 0) > 0) Text(" (${container.entity.itemCount})")
            ])),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                child: InkWell(
                  onTap: () {
                    _workspaceNavigator.toggleSharesForContainer(container);
                  }, // TODO: show shares for container
                  child: container.entity.accessors[AccessorUtils.anyLevelKey].length == 1
                      ? Icon(Icons.person)
                      : Row(children: [
                          Text("${container.entity.accessors[AccessorUtils.anyLevelKey].length} ",
                              style: Theme.of(context).textTheme.bodyText1),
                          Icon(Icons.group)
                        ]),
                )),
          ],
        ),
        trailing: PopupMenuButton<ListContainerMenuItem>(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ListContainerMenuItem.delete,
                    child: Row(children: [
                      Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Delete ${container.entity.name}")),
                      Icon(Icons.delete)
                    ]),
                  )
                ],
            onSelected: (ListContainerMenuItem selected) {
              switch (selected) {
                case ListContainerMenuItem.delete:
                  _workspace.delete(container);
                  break;
              }
            }),
        onTap: () {
          _workspaceNavigator.toggleSelectedContainer(container);
        });
  }

  Icon get icon => _containerIcons[container.entity.type] ?? _defaultIcon;

  static const Map<ContainerType, Icon> _containerIcons = {
    ContainerType.todo: Icon(Icons.check_box),
    ContainerType.shopping: Icon(Icons.shopping_cart)
  };

  static const Icon _defaultIcon = Icon(Icons.highlight);
}

enum ListContainerMenuItem { delete }
