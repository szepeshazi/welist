import 'package:animate_do/animate_do.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import 'login_register_navigator.dart';

class ConfirmRegistrationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);
    final AuthService _authService = Provider.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: SingleChildScrollView(
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
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
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
                            isLoading: _authService.status == UserStatus.verificationRequired,
                            onSuccess: (_) {
                              _loginRegisterNavigator.confirmScreenDone();
                            },
                            onError: (err, stack) {
                              print(err);
                            },
                          ))),
                  Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      child: Center(child: Text(messageResend, style: Theme.of(context).textTheme.bodyText1))),
                  Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      child: ElevatedButton(
                          child: Text("Resend email"),
                          //onPressed: null)),
                          onPressed: _authService.resendVerificationEmailDisabled
                              ? null
                              : () {
                                  _authService.sendVerificationEmailIfPermitted();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Verification email sent"),
                                  ));
                                })),
                  Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      child: Center(child: Text(messageOtherAction, style: Theme.of(context).textTheme.bodyText1))),
                  Container(
                      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      child: ElevatedButton(
                          child: Text("Log in with another account"),
                          onPressed: () {
                            _authService.signOut();
                          }))
                ]),
              )),
        ),
      ),
    );
  }

  static const String messageTitle = 'Thank you for signing up!';

  static const String messageBody = '''
We've sent you an email with a confirmation link - please activate your account by clicking the link to continue.''';

  static const String messageResend = 'If you did not receive the confirmation email, let us send it again.';

  static const String messageOtherAction = 'Alternatively, you can log in with another account.';
}
