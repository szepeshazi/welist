import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:welist/auth/auth.dart';

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context);
    return Row(children: [
      Text(auth.user.displayName ?? auth.user.email.split("@").first),
      Container(padding: EdgeInsets.only(left: 10), child: Icon(Icons.account_circle)),
      PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(children: [
                    Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Profile")),
                    Icon(Icons.settings)
                  ]),
                ),
                PopupMenuItem(
                    value: 2,
                    child: Row(children: [
                      Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Logout")),
                      Icon(Icons.exit_to_app)
                    ]))
              ])
    ]);
  }
}
