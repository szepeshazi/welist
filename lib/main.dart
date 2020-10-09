import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welist/navigation/main_page.dart';
import 'package:welist/view_list/view_list_widget.dart';
import 'package:welist/workspace/list_container_shares.dart';
import 'package:welist/workspace/workspace_widget.dart';

import 'auth/auth.dart';
import 'login_ui/login_screen.dart';
import 'login_ui/transition_route_observer.dart';
import 'splash/splash_widget.dart';
import 'workspace/create_list_widget.dart';

void main() => runApp(WeListApp());

class WeListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<Auth>(create: (_) => Auth()..initialize()), Provider<MainPage>(create: (_) => MainPage())],
        child: MainContainer());
  }
}

// MainContainer with Observer
class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      title: 'WeList',
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[500],
          accentColor: Colors.deepOrange[300]),
      home: WorkspaceWidget()
    );
    return app;
  }
}

class WeListHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WorkspaceWidget();
}

class Routes {
  // Route name constants
  static const String splash = "/spash";
  static const String login = '/login';
  static const String home = '/home';
  static const String createList = '/createList';
  static const String viewList = '/viewList';
  static const String createItem = "/createItem";
  static const String listContainerShares = "/listContainerShares";

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.splash: (context) => WorkspaceWidget(),
      Routes.login: (context) => LoginScreen(),
      Routes.home: (context) => WeListHome(),
      Routes.createList: (context) => CreateListContainerWidget(),
      Routes.viewList: (context) => ViewListWidget(),
      Routes.createItem: (context) => CreateListContainerWidget(),
      Routes.listContainerShares: (context) => ListContainerSharesWidget()
    };
  }
}
