import 'package:mobx/mobx.dart';

import '../auth/auth_service.dart';

part 'main_page_navigator.g.dart';

class MainPageNavigator = _MainPageNavigator with _$MainPageNavigator;

abstract class _MainPageNavigator with Store {
  final AuthService _authService;

  /// Main widget to display based on internal states
  @observable
  MainWidget mainWidget = MainWidget.splashAnimation;

  /// Internal state variables
  bool _authInitialized = false;
  UserStatus _userStatus;

  bool _splashModuleActive = true;
  bool _loginModuleActive = false;

  _MainPageNavigator(this._authService) {
    reaction((_) => _authService.status, (authStatus) {
      _userStatus = authStatus;
      _computeState();
    });
    reaction((_) => _authService.initialized, (authInitialized) {
      _authInitialized = authInitialized;
      _computeState();
    });
  }

  @action
  void loginModuleDone() {
    _loginModuleActive = false;
    _computeState();
  }

  @action
  void splashModuleDone() {
    _splashModuleActive = false;
    _computeState();
  }

  void _computeState() {
    MainWidget requiredWidget;
    if (_splashModuleActive || !_authInitialized) {
      requiredWidget = MainWidget.splashAnimation;
      _splashModuleActive = true;
    } else if (_userStatus == UserStatus.loggedIn && !_loginModuleActive) {
      requiredWidget = MainWidget.workSpace;
    } else {
      requiredWidget = MainWidget.loginRegister;
      _loginModuleActive = true;
    }
    print("MainPageNavigator computeState, previous: $mainWidget, current: $requiredWidget");
    if (requiredWidget != mainWidget) {
      mainWidget = requiredWidget;
    }
  }
}

enum MainWidget { splashAnimation, loginRegister, workSpace }
