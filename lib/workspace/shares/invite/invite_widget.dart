import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/auth/auth_service.dart';

import '../../../juiced/juiced.dart';
import '../../../profile/user_info_widget.dart';
import '../shares_navigator.dart';
import 'invite.dart';
import 'invite_service.dart';

class InviteWidget extends StatelessWidget {
  final ListContainer container;

  const InviteWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of(context);
    return MultiProvider(providers: [
      Provider<InviteService>(create: (_) => InviteService(_authService)),
      Provider<Invite>(create: (_) => Invite())
    ], child: InviteInnerWidget(container: container));
  }
}

class InviteInnerWidget extends StatelessWidget {
  final ListContainer container;

  const InviteInnerWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Invite invite = Provider.of(context);
    final InviteService inviteService = Provider.of(context);
    final SharesNavigator sharesNavigator = Provider.of(context);

    return Scaffold(
        appBar: AppBar(title: Text("Add accessor"), actions: [UserInfoWidget()]),
        body: Form(
            child: Center(
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Wrap(children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 20),
                          child:
                              Text("Invite users to access this list", style: Theme.of(context).textTheme.headline6)),
                      Card(
                        child: Container(
                          color: Color(0xFFF8F8FF),
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Enter email address"),
                            onChanged: (value) => invite.setRecipientEmail(value),
                          ),
                        ),
                      ),
                      Card(
                          child: Container(
                        color: Color(0xFFF8F8FF),
                        padding: EdgeInsets.all(15),
                        child: Observer(
                            builder: (context) => Column(
                                  children: [
                                    for (final level in ContainerAccess.levels)
                                      ListTile(
                                          title: Text(ContainerAccess.labels[level]),
                                          leading: Radio(
                                              value: level,
                                              groupValue: invite.accessLevel,
                                              onChanged: (String value) => invite.setAccessLevel(value)),
                                          subtitle: Text("Some explanation about this role"),
                                          visualDensity: VisualDensity.compact),
                                  ],
                                )),
                      )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 25),
                          child: Observer(
                            builder: (context) => ElevatedButton(
                                onPressed: () {
                                  sharesNavigator.toggleAddAccessorButton(true);
                                  inviteService
                                      .send(
                                          recipientEmail: invite.recipientEmail,
                                          accessLevel: invite.accessLevel,
                                          subjectUid: container.reference.id)
                                      .then((_) => sharesNavigator.toggleAddAccessorForm(false));
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    child: Text("Invite", textScaleFactor: 1.5))),
                          ))
                    ])))));
  }
}
