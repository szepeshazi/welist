import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/juiced/juiced.dart';

import '../main.dart';
import '../workspace/workspace.dart';

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My lists")),
        body: ListContainersWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, Routes.createList);
            }));
  }
}

class ListContainersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    return Observer(
        builder: (context) => ListView.builder(
            padding: const EdgeInsets.all(8),
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
    return ListTile(title: Text(container.name), trailing: icons[container.type] ?? defaultIcon);
  }

  static const Map<ContainerType, Icon> icons = {
    ContainerType.shopping: Icon(Icons.shopping_cart),
    ContainerType.todo: Icon(Icons.check_box)
  };

  static const Icon defaultIcon = Icon(Icons.not_interested);
}
