import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../shared/common.dart';
import 'confirm_registration_widget.dart';
import 'login_register_navigator.dart';
import 'login_widget.dart';

class LoginRegisterWidget extends StatelessWidget {
  final NotifyParent notifyParent;

  LoginRegisterWidget(this.notifyParent);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<LoginRegisterNavigator>(
          create: (_) => LoginRegisterNavigator(auth: context.read<Auth>(), notifyParent: notifyParent))
    ], child: Scaffold(body: LoginRegisterWrapper()));
  }
}

class LoginRegisterWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);

    return Observer(
        builder: (context) => Navigator(
                pages: [
                  if (_loginRegisterNavigator.loginWidgetKind == LoginWidgetKind.login)
                    MaterialPage(key: ValueKey("login/login"), name: "login/login", child: LoginWidget()),
                  if (_loginRegisterNavigator.loginWidgetKind == LoginWidgetKind.confirm)
                    MaterialPage(
                        key: ValueKey("login/confirm"), name: "login/confirm", child: ConfirmRegistrationWidget()),
                ],
                onPopPage: (route, result) {
                  if (!route.didPop(result)) {
                    return false;
                  }
                  if (route.settings.name == "login/confirm") {
                    _loginRegisterNavigator.abortConfirmation();
                  }
                  return true;
                }));
  }
}
