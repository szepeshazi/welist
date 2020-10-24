import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../juiced/juiced.dart';
import '../../profile/user_info_widget.dart';
import 'invite_widget.dart';
import 'list_container_shares.dart';
import 'shares_navigator.dart';

class ListContainerSharesWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerSharesWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<ListContainerShares>(create: (_) => ListContainerShares(container)..load()),
      Provider<SharesNavigator>(create: (_) => SharesNavigator())
    ], child: ListContainerSharesNavigatorWidget(container: container));
  }
}

class ListContainerSharesNavigatorWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerSharesNavigatorWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SharesNavigator _sharesNavigator = Provider.of(context);
    return Observer(
        builder: (context) => Navigator(
            key: GlobalKey(debugLabel: "second"),
            pages: [
              MaterialPage(
                  key: ValueKey("container/shares"),
                  name: "container/shares",
                  child: ListContainerShareListWidget(container: container)),
              if (_sharesNavigator.showAddAccessorForm)
                MaterialPage(key: ValueKey("container/shares/add"), name: "container/shares/add", child: InviteWidget())
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              print("ListContainerSharesNavigatorWidget widget, popping: ${route.settings.name}");
              if (route.settings.name == "container/shares/add") {
                _sharesNavigator.toggleAddAccessorForm(false);
              }
              return true;
            }));
  }
}

class ListContainerShareListWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerShareListWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListContainerShares shares = Provider.of(context);
    final SharesNavigator _sharesNavigator = Provider.of(context);

    return Scaffold(
        appBar: AppBar(title: Text("${container.name} accessors"), actions: [UserInfoWidget()]),
        body: Observer(
            builder: (context) => shares.shares == null
                ? Center(child: Text("soon"))
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 8),
                    shrinkWrap: true,
                    itemCount: shares.shares.length,
                    itemBuilder: (BuildContext context, index) => AccessorWidget(displayShare: shares.shares[index]))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _sharesNavigator.toggleAddAccessorForm(true);
            }));
  }
}

class AccessorWidget extends StatelessWidget {
  final DisplayShare displayShare;

  const AccessorWidget({Key key, this.displayShare}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(children: [
            Container(padding: EdgeInsets.only(right: 5.0), child: Icon(Icons.account_circle)),
            Text("${displayShare.email} (${displayShare.role})"),
          ]))
        ],
      ),
      trailing: Icon(Icons.more_vert));
}
