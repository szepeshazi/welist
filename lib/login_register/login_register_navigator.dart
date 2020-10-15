import 'package:mobx/mobx.dart';
import '../auth/auth.dart';

part 'login_register_navigator.g.dart';

class LoginRegisterNavigator = _LoginRegisterNavigator with _$LoginRegisterNavigator;

abstract class _LoginRegisterNavigator with Store {

  final Auth auth;

  @observable
  LoginState loginState;

  @observable
  bool showResendEmailButton = true;

  _LoginRegisterNavigator(this.auth) {
    autorun((_) {
      switch(auth.status) {
        case UserStatus.loggedOut:
          loginState = LoginState.login;
          break;
        case UserStatus.verificationRequired:
          loginState = LoginState.confirm;
          break;
        case UserStatus.loggedIn:
          print("login already concluded");
          break;
      }
    });
  }


  @action
  void setState(LoginState newState) => loginState = newState;

  @action
  void toggleResendEmailButton(bool newValue) => showResendEmailButton = newValue;
}

enum LoginState { login, confirm }