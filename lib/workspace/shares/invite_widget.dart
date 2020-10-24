import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../profile/user_info_widget.dart';

class InviteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Add accessor"), actions: [UserInfoWidget()]), body: null);
  }
}
