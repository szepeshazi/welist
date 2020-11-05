import 'package:mobx/mobx.dart';

import '../auth/auth_service.dart';
import '../shared/common.dart';

part 'login_register_navigator.g.dart';

class LoginRegisterNavigator = _LoginRegisterNavigator with _$LoginRegisterNavigator;

abstract class _LoginRegisterNavigator with Store {
  final AuthService authService;

  final NotifyParent notifyParent;

  @observable
  LoginWidgetKind loginWidgetKind = LoginWidgetKind.login;

  _LoginRegisterNavigator({this.authService, this.notifyParent}) {
    if (authService.status == UserStatus.verificationRequired) {
      loginWidgetKind = LoginWidgetKind.confirm;
    }
  }

  @action
  void loginScreenDone() {
    if (authService.status == UserStatus.loggedIn) {
      notifyParent();
    } else {
      loginWidgetKind = LoginWidgetKind.confirm;
    }
  }

  @action
  void confirmScreenDone() {
    if (authService.status == UserStatus.loggedIn) {
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
