import 'dart:math';

import 'package:mobx/mobx.dart';

import '../auth/auth.dart';
import '../shared/common.dart';

part 'login_register_navigator.g.dart';

class LoginRegisterNavigator = _LoginRegisterNavigator with _$LoginRegisterNavigator;

abstract class _LoginRegisterNavigator with Store {
  final Auth auth;

  final NotifyParent notifyParent;

  @observable
  LoginWidgetKind loginWidgetKind = LoginWidgetKind.login;

  _LoginRegisterNavigator({this.auth, this.notifyParent}) {
    if (auth.status == UserStatus.verificationRequired) {
      loginWidgetKind = LoginWidgetKind.confirm;
    }
  }

  @action
  void loginScreenDone() {
    if (auth.status == UserStatus.loggedIn) {
      notifyParent();
    } else {
      loginWidgetKind = LoginWidgetKind.confirm;
    }
  }

  @action
  void confirmScreenDone() {
    if (auth.status == UserStatus.loggedIn) {
      notifyParent();
    } else {
      loginWidgetKind = LoginWidgetKind.login;
    }
  }

  @action
  void abortConfirmation() {
    loginWidgetKind = LoginWidgetKind.login;
  }
}

enum LoginWidgetKind { login, confirm }
