import 'package:mobx/mobx.dart';

import '../auth/auth.dart';

part 'main_page_navigator.g.dart';

class MainPageNavigator = _MainPageNavigator with _$MainPageNavigator;

abstract class _MainPageNavigator with Store {
  final Auth auth;

  /// Main widget to display based on internal states
  @observable
  MainWidget mainWidget = MainWidget.splashAnimation;

  /// Internal state variables
  bool _authInitialized = false;
  UserStatus _userStatus;
  bool _splashAnimationInProgress = true;
  bool _loginAnimationInProgress = false;

  _MainPageNavigator(this.auth) {
    reaction((_) => auth.status, (authStatus) {
      _userStatus = authStatus;
      _evaluateState();
    });
    reaction((_) => auth.initialized, (authInitialized) {
      _authInitialized = authInitialized;
      _evaluateState();
    });
  }

  @action
  void updateSplashScreenStatus(bool active) {
    _splashAnimationInProgress = active;
    _evaluateState();
  }

  @action
  void updateLoginScreenStatus(bool active) {
    _loginAnimationInProgress = active;
    _evaluateState();
  }

  void _evaluateState() {
    MainWidget requiredWidget;
    if (_splashAnimationInProgress || !_authInitialized) {
      requiredWidget = MainWidget.splashAnimation;
    } else if (_authInitialized && _userStatus == UserStatus.loggedIn && !_loginAnimationInProgress) {
      requiredWidget = MainWidget.workSpace;
    } else {
      requiredWidget = MainWidget.loginRegister;
      _loginAnimationInProgress = true;
    }
    if (requiredWidget != mainWidget) {
      mainWidget = requiredWidget;
    }
  }
}

enum MainWidget { splashAnimation, loginRegister, workSpace }
