import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../profile/user_info_widget.dart';

class NotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Notifications"), actions: [UserInfoWidget()]), body: Text("Notifs"));
  }
}
