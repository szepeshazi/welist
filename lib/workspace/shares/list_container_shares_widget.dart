import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_service.dart';
import '../../juiced/juiced.dart';
import '../../profile/user_info_widget.dart';
import 'shares_navigator.dart';
import 'shares_service.dart';

class ListContainerSharesWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerSharesWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of(context);
    return MultiProvider(
        providers: [Provider<SharesService>(create: (_) => SharesService(container, _authService)..load())],
        child: ListContainerShareListWidget(container: container));
  }
}

class ListContainerShareListWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerShareListWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SharesService shares = Provider.of(context);
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
                    itemBuilder: (BuildContext context, index) {
                      final item = shares.shares[index];
                      return ListTile(
                        title: item.buildTitle(context),
                        subtitle: item.buildSubtitle(context),
                      );
                    })),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _sharesNavigator.toggleAddAccessorForm(true);
            }));
  }
}
