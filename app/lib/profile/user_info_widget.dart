import 'dart:async';

import 'package:animate_do/animate_do.dart' as anim;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../shared/animation_director/animation_director.dart';
import '../workspace/shares/invite/invite_service.dart';
import '../workspace/workspace_navigator.dart';

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of(context);
    final InviteService _inviteService = Provider.of(context);

    return Observer(
        builder: (context) => Row(children: [
              Text(_authService.user.displayName ?? _authService.user.email.split("@").first),
              Container(padding: EdgeInsets.only(left: 10), child: Icon(Icons.account_circle)),
              if (_inviteService.received.isNotEmpty)
                Container(padding: EdgeInsets.only(left: 10), child: NotificationIndicatorWidget()),
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
                    switch (selected) {
                      case ProfileMenuItem.settings:
                        // TODO: profile menu
                        break;
                      case ProfileMenuItem.logout:
                        // TODO: fixed delay
                        Future.delayed(Duration(milliseconds: 250)).then((_) => FirebaseAuth.instance.signOut());
                        break;
                    }
                  })
            ]));
  }
}

class NotificationIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkspaceNavigator _navigator = Provider.of(context);
    final director = AnimationDirector(3)..register(AnimationConfig(id: 'delay', delay: Duration(seconds: 2)))(null);
    StreamSubscription directorListener;
    directorListener = director.completed.listen((bool completed) {
      if (completed) {
        //_notifyParent();
        directorListener.cancel();
      }
    });

    return anim.Swing(
        child: anim.Pulse(
          child: IconButton(
              onPressed: () {
                _navigator.toggleNotifications(!_navigator.showNotifications);
              },
              icon: Icon(Icons.message),
              color: Colors.limeAccent),
          controller:
              director.register(AnimationConfig(id: 'zoomin', dependsOn: 'delay')),
          manualTrigger: true,
          animate: false,
        ),
        controller:
            director.register(AnimationConfig(id: 'swing', dependsOn: 'delay')),
        manualTrigger: true,
        animate: false);
  }
}

enum ProfileMenuItem { settings, logout }
