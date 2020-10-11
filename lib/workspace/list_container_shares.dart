import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../juiced/juiced.dart';
import '../profile/user_info_widget.dart';

class ListContainerSharesWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerSharesWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${container.name} accessors"), actions: [UserInfoWidget()]),
        body: ListContainerShareListWidget(container: container));
  }
}

class ListContainerShareListWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerShareListWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(left: 8),
        shrinkWrap: true,
        itemCount: container.accessors.length ?? 0,
        itemBuilder: (BuildContext context, index) => AccessorWidget(userRole: container.accessors[index]));
  }
}

class AccessorWidget extends StatelessWidget {
  final UserRole userRole;

  const AccessorWidget({Key key, this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(children: [
            Container(padding: EdgeInsets.only(right: 5.0), child: Icon(Icons.account_circle)),
            Text(userRole.user.email),
            Container(padding: EdgeInsets.only(left: 5.0), child: Text("- ${userRole.role}"))
          ]))
        ],
      ),
      trailing: Icon(Icons.more_vert));
}
