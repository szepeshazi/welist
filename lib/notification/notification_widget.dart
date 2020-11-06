import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../profile/user_info_widget.dart';
import '../workspace/shares/invite/invite_service.dart';
import 'notification_store.dart';

class NotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<NotificationStore>(create: (_) => NotificationStore(context.read<InviteService>())..initialize())
    ], child: NotificationListWidget());
  }
}

class NotificationListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotificationStore _notificationStore = Provider.of(context);

    return Scaffold(
        appBar: AppBar(title: Text("Notification"), actions: [UserInfoWidget()]),
        body: Observer(
            builder: (context) => _notificationStore.notifications == null
                ? Center(child: Text("soon"))
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 8),
                    shrinkWrap: true,
                    itemCount: _notificationStore.notifications.length,
                    itemBuilder: (BuildContext context, index) {
                      final item = _notificationStore.notifications[index];
                      return ListTile(
                        title: item.buildTitle(context),
                        subtitle: item.buildSubtitle(context),
                        trailing: item.buildTrailing(context),
                        isThreeLine: true
                      );
                    })));
  }
}
