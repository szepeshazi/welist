import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth.dart';
import 'main_page/main_page_navigator.dart';
import 'main_page/main_page_widget.dart';

void main() => runApp(WeListApp());

/// Top level wrapper widget to provide Auth instance
class WeListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [Provider<Auth>(create: (_) => Auth()..initialize())], child: MainContainer());
  }
}

/// Intermediate wrapper widget to build Material App and provide MainPage navigator instance
class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<MainPageNavigator>(create: (_) => MainPageNavigator(context.read<Auth>()))],
        child: MaterialApp(
            title: 'WeList',
            theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.lightBlue[500],
                accentColor: Colors.deepOrange[300],
                fontFamily: "Roboto"),
            home: MainPageWidget()));
  }
}
