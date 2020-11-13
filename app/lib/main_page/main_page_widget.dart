import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../login_register/login_register_widget.dart';
import '../splash/splash_widget.dart';
import '../workspace/workspace_widget.dart';
import 'main_page_navigator.dart';

/// MainPageWidget to route among primary widgets: Splash, Login and Workspace
class MainPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPageNavigator _mainPageNavigator = Provider.of(context);
    return Observer(
        builder: (context) => Navigator(pages: [
              if (_mainPageNavigator.mainWidget == MainWidget.splashAnimation)
                MaterialPage(
                    key: ValueKey("splash"),
                    name: "splash",
                    child: SplashWidget(([_]) => _mainPageNavigator.splashModuleDone())),
              if (_mainPageNavigator.mainWidget == MainWidget.loginRegister)
                MaterialPage(
                    key: ValueKey("login"),
                    name: "login",
                    child: LoginRegisterWidget(([_]) => _mainPageNavigator.loginModuleDone())),
              if (_mainPageNavigator.mainWidget == MainWidget.workSpace)
                MaterialPage(key: ValueKey("workspace"), name: "workspace", child: WorkspaceWidget())
            ], onPopPage: (route, result) => route.didPop(result)));
  }
}
