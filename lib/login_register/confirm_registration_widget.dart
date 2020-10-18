import 'package:animate_do/animate_do.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import 'login_register_navigator.dart';

class ConfirmRegistrationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);
    final Auth _auth = Provider.of(context);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Container(
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Observer(
              builder: (context) =>
                  Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                Container(
                    margin: EdgeInsets.all(25),
                    child: Center(child: Text(messageTitle, style: Theme.of(context).textTheme.headline5))),
                Container(
                    margin: EdgeInsets.all(25),
                    child: Center(child: Text(messageBody, style: Theme.of(context).textTheme.bodyText1))),
                ZoomIn(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        color: Theme.of(context).accentColor,
                        child: FlareLoading(
                          name: 'assets/flares/liquid_download.flr',
                          loopAnimation: 'Indeterminate',
                          startAnimation: 'Indeterminate',
                          endAnimation: 'Complete',
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                          isLoading: _auth.status == UserStatus.verificationRequired,
                          onSuccess: (_) {
                            _loginRegisterNavigator.confirmScreenDone();
                          },
                          onError: (err, stack) {
                            print(err);
                          },
                        ))),
                Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: ElevatedButton(child: Text("Resend E-mail"), onPressed: () {}))
              ]),
            )),
      ),
    );
  }

  static const String messageTitle = 'Thank you for signing up!';

  static const String messageBody = '''
Welcome to WeList, the ultimate tool for sharing groceries, todo lists and more.

You are one step away to start your lists - we just need your email address confirmed.

We've sent you an E-mail with a confirmation link - please activate your account by clicking the link to continue.''';
}
