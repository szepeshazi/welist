import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist_common/common.dart';

import '../../auth/auth_service.dart';
import '../../common/common.dart';
import '../../profile/user_info_widget.dart';
import 'invite/invite_service.dart';
import 'shares_navigator.dart';
import 'shares_service.dart';
import 'shares_store.dart';

class ListContainerSharesWidget extends StatelessWidget {
  final FirestoreEntity<ListContainer> container;

  const ListContainerSharesWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of(context);
    return MultiProvider(
        providers: [Provider<SharesService>(create: (_) => SharesService(container, _authService)..initialize())],
        child: ListContainerInnerWidget(container: container));
  }
}

class ListContainerInnerWidget extends StatelessWidget {
  final FirestoreEntity<ListContainer> container;

  const ListContainerInnerWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of(context);
    final SharesService _sharesService = Provider.of(context);
    final InviteService _inviteService = Provider.of(context);
    return MultiProvider(providers: [
      Provider<SharesStore>(
          create: (_) => SharesStore(container, _authService, _sharesService, _inviteService)..initialize())
    ], child: ListContainerShareListWidget(container: container));
  }
}

class ListContainerShareListWidget extends StatelessWidget {
  final FirestoreEntity<ListContainer> container;

  const ListContainerShareListWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SharesStore _sharesStore = Provider.of(context);
    final SharesNavigator _sharesNavigator = Provider.of(context);

    return Scaffold(
        appBar: AppBar(title: Text("${container.entity.name} accessors"), actions: [UserInfoWidget()]),
        body: Observer(
            builder: (context) => _sharesStore.sharesAndInvites == null
                ? Center(child: Text("soon"))
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 8),
                    shrinkWrap: true,
                    itemCount: _sharesStore.sharesAndInvites.length,
                    itemBuilder: (BuildContext context, index) {
                      final item = _sharesStore.sharesAndInvites[index];
                      return ListTile(
                        title: item.buildTitle(context),
                        subtitle: item.buildSubtitle(context),
                        trailing: item.buildTrailing(context),
                      );
                    })),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _sharesNavigator.toggleAddAccessorForm(true);
            }));
  }
}
