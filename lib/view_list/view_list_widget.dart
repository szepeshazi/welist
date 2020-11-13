import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist_common/common.dart';

import '../auth/auth_service.dart';
import '../profile/user_info_widget.dart';
import '../workspace/list_container_service.dart';
import 'create_multi_item_widget.dart';
import 'list_item_service.dart';

class ViewListWidget extends StatelessWidget {
  final ListContainer container;

  const ViewListWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<ListItemService>(
          create: (_) => ListItemService(container, context.read<AuthService>(),
              context.read<ListContainerService>())
            ..initialize())
    ], child: ViewListWidgetInner());
  }
}

class ViewListWidgetInner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListItemService viewList = Provider.of(context);
    return Scaffold(
        appBar: AppBar(
            title: Text(viewList.container.name), actions: [UserInfoWidget()]),
        body: ViewListWrapperWidget(),
        floatingActionButton: Observer(
            builder: (context) => InkWell(
                splashColor: Colors.blue,
                onLongPress: () {
                  viewList.setMultiEditMode(!viewList.multiEditMode);
                },
                child: FloatingActionButton(
                    child:
                        Icon(viewList.multiEditMode ? Icons.remove : Icons.add),
                    onPressed: () {
                      // TODO: add a single item to list
                    }))));
  }
}

class ViewListWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListItemService viewList = Provider.of(context);
    return Provider(
        create: (_) => null,
        child: Observer(
            builder: (context) => Column(children: [
                  if (viewList.multiEditMode) CreateMultiItemWidget(),
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: viewList.items?.length ?? 0,
                      itemBuilder: (BuildContext context, index) =>
                          ListItemRowWidget(item: viewList.items[index]))
                ])));
  }
}

class ListItemRowWidget extends StatelessWidget {
  final ListItem item;

  const ListItemRowWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListItemService viewList = Provider.of(context);
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: item.completed,
        onChanged: (bool newValue) {
          item.setState(newValue);
          viewList.update(item);
        },
        title: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              item.name,
              overflow: TextOverflow.ellipsis,
            )),
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => viewList.delete(item))
          ],
        ),
        subtitle: Text(item.stateName,
            textAlign: TextAlign.start, overflow: TextOverflow.ellipsis));
  }
}
