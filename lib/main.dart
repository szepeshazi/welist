import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation/main_page.dart';
import 'workspace/workspace_widget.dart';

import 'auth/auth.dart';

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
