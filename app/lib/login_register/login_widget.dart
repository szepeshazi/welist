import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import 'constants.dart';
import 'login_register_navigator.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginRegisterNavigator _loginRegisterNavigator = Provider.of(context);
    final AuthService _authService = Provider.of(context);

    return FlutterLogin(
      title: Constants.appName,
      titleTag: Constants.titleTag,
      theme: LoginTheme(
          titleStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Quicksand',
            letterSpacing: 4,
          ),
          beforeHeroFontSize: 50,
          afterHeroFontSize: 20),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: _loginFunction(_authService),
      onSignup: _registerFunction(_authService),
      onSubmitAnimationCompleted: () => _loginRegisterNavigator.loginScreenDone(),
      onRecoverPassword: _recoverPasswordFunction(_authService),
      showDebugButtons: false,
    );
  }

  final AuthCallback Function(AuthService) _registerFunction = (AuthService auth) => (LoginData loginData) async {
        String result;
        try {
          await auth.register(loginData.name, loginData.password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            result = 'Password is weak (should be at least 6 chars)';
          } else if (e.code == 'email-already-in-use') {
            result = 'The account already exists for that email.';
          }
        } catch (e) {
          result = e.toString();
        }
        return result;
      };

  final AuthCallback Function(AuthService) _loginFunction = (AuthService auth) => (LoginData loginData) async {
        String result;
        try {
          await auth.login(loginData.name, loginData.password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            result = 'User not found';
          } else if (e.code == 'wrong-password') {
            result = 'Password mismatch';
          }
        }
        return result;
      };

  final RecoverCallback Function(AuthService) _recoverPasswordFunction = (AuthService auth) => (String email) async {
        String result;
        try {
          await auth.resetPassword(email);
        } catch (e) {
          result = e.toString();
        }
        return result;
      };
}

typedef AuthCallback = Future<String> Function(LoginData);

typedef RecoverCallback = Future<String> Function(String);
