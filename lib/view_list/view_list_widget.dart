import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/juiced/juiced.dart';

import '../main.dart';
import 'create_multi_item_widget.dart';
import 'view_list.dart';

class ViewListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListContainer container = ModalRoute.of(context).settings.arguments;
    return MultiProvider(
        providers: [Provider<ViewList>(create: (_) => ViewList(container)..initialize())],
        child: ViewListWidgetInner());
  }
}

class ViewListWidgetInner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ViewList viewList = Provider.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(viewList.container.name)),
        body: ViewListWrapperWidget(),
        floatingActionButton: Observer(
            builder: (context) => InkWell(
                splashColor: Colors.blue,
                onLongPress: () {
                  viewList.setMultiEditMode(!viewList.multiEditMode);
                },
                child: FloatingActionButton(
                    child: Icon(viewList.multiEditMode ? Icons.remove : Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.createList);
                    }))));
  }
}

class ViewListWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ViewList viewList = Provider.of(context);
    return Observer(
        builder: (context) => Column(children: [
              if (viewList.multiEditMode) CreateMultiItemWidget(),
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: viewList.items?.length ?? 0,
                  itemBuilder: (BuildContext context, index) => ListItemRowWidget(item: viewList.items[index]))
            ]));
  }
}

class ListItemRowWidget extends StatelessWidget {
  final ListItem item;

  const ListItemRowWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ViewList viewList = Provider.of(context);
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: item.completed,
        onChanged: (bool newValue) => item.setState(newValue),
        title: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              item.name,
              overflow: TextOverflow.ellipsis,
            )),
            IconButton(icon: const Icon(Icons.delete), onPressed: () => viewList.delete(item))
          ],
        ),
        subtitle: Text(item.stateName, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis));
  }
}
