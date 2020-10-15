import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import 'confirm_registration_widget.dart';
import 'login_register_navigator.dart';
import 'login_widget.dart';

class LoginRegisterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<LoginRegisterNavigator>(create: (_) => LoginRegisterNavigator(context.read<Auth>()))],
        child: null);
  }
}

class LoginRegisterWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);

    return Navigator(
        pages: [
          if (_loginRegisterNavigator.loginState == LoginState.login)
            MaterialPage(key: ValueKey("login/login"), name: "login/login", child: LoginWidget()),
          if (_loginRegisterNavigator.loginState == LoginState.confirm)
            MaterialPage(key: ValueKey("login/confirm"), name: "login/confirm", child: ConfirmRegistrationWidget()),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        });
  }
}
