import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/auth/auth.dart';
import 'package:welist/juiced/juiced.dart';
import 'package:welist/profile/user_info_widget.dart';

import '../main.dart';
import '../workspace/workspace.dart';

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context);
    reaction((_) => auth.user, (user) {
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => true);
      }
    });
    return MultiProvider(
        providers: [
          Provider<Workspace>(create: (context) => Workspace(Provider.of<Auth>(context, listen: false))..initialize())
        ],
        child: Scaffold(
            appBar: AppBar(title: Text("My lists"), actions: [UserInfoWidget()]),
            body: ListContainersWidget(),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.createList);
                })));
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
                  onTap: () => Navigator.pushNamed(context, Routes.listContainerShares, arguments: container),
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
          Navigator.pushNamed(context, Routes.viewList, arguments: container);
        });
  }
}

enum ListContainerMenuItem { delete }
