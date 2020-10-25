import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../juiced/juiced.dart';
import '../../../profile/user_info_widget.dart';
import 'invite.dart';

class InviteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MultiProvider(providers: [Provider<Invite>(create: (_) => Invite())], child: InviteInnerWidget());
}

class InviteInnerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Invite _invite = Provider.of(context);
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
                              Text("Invite users to access this list", style: Theme.of(context).textTheme.headline5)),
                      Card(
                        child: Container(
                          color: Color(0xFFF8F8FF),
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Enter email address"),
                            onChanged: (value) => _invite.setRecipientEmail(value),
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
                                              groupValue: _invite.accessLevel,
                                              onChanged: (String value) => _invite.setAccessLevel(value)),
                                          subtitle: Text("Some explanation about this role"),
                                          visualDensity: VisualDensity.compact),
                                  ],
                                )),
                      )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 25),
                          child: ElevatedButton(onPressed: () {}, child: Text("Invite", textScaleFactor: 1.5)))
                    ])))));
  }
}