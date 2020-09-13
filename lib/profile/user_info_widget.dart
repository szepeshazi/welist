import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:welist/auth/auth.dart';

import '../main.dart';

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context);
    return Row(children: [
      Text(auth.user.displayName ?? auth.user.email.split("@").first),
      Container(padding: EdgeInsets.only(left: 10), child: Icon(Icons.account_circle)),
      PopupMenuButton<ProfileMenuItem>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: ProfileMenuItem.settings,
                  child: Row(children: [
                    Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Profile")),
                    Icon(Icons.settings)
                  ]),
                ),
                PopupMenuItem(
                    value: ProfileMenuItem.logout,
                    child: Row(children: [
                      Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Logout")),
                      Icon(Icons.exit_to_app)
                    ]))
              ],
      onSelected: (ProfileMenuItem selected) {
            switch(selected) {
              case ProfileMenuItem.settings:
               Navigator.pushNamed(context, Routes.home);
                break;
              case ProfileMenuItem.logout:
                FirebaseAuth.instance.signOut();
                break;
            }
      })
    ]);
  }
}

enum ProfileMenuItem {
  settings, logout
}
