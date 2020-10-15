import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../main_page/main_page_navigator.dart';
import 'constants.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPageNavigator _mainPageNavigator = Provider.of(context);
    final Auth _auth = Provider.of(context);

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
      onLogin: _loginFunction(_auth),
      onSignup: _registerFunction(_auth),
      onSubmitAnimationCompleted: () {
        // TODO login or register successful
        _mainPageNavigator.updateLoginScreenStatus(false);
      },
      onRecoverPassword: _recoverPasswordFunction(_auth),
      showDebugButtons: false,
    );
  }

  final AuthCallback Function(Auth) _registerFunction = (Auth auth) => (LoginData loginData) async {
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

  final AuthCallback Function(Auth) _loginFunction = (Auth auth) => (LoginData loginData) async {
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

  final RecoverCallback Function(Auth) _recoverPasswordFunction = (Auth auth) => (String email) async {
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
