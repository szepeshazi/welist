import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/workspace/workspace.dart';
import 'package:welist/workspace/workspace_widget.dart';

import 'auth/auth.dart';
import 'login_ui/login_screen.dart';
import 'login_ui/transition_route_observer.dart';
import 'splash/splash.dart';
import 'workspace/create_list_widget.dart';

void main() => runApp(WeListApp());

class WeListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<Auth>(create: (_) => Auth()..initialize()),
      Provider<Workspace>(create: (context) => Workspace(Provider.of<Auth>(context, listen: false))..initialize())
    ], child: MainContainer());
  }
}

// MainContainer with Observer
class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context);
    return MaterialApp(
      title: 'WeList',
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[500],
          accentColor: Colors.deepOrange[300]),
      home: Observer(
          name: "MainContainerObserver",
          builder: (BuildContext context) {
            Widget widget;
            if (!auth.initialized) {
              print("#### ${DateTime.now().millisecondsSinceEpoch} Creating widget Splash");
              widget = Splash();
            } else if (auth.uiUser != null) {
              print("#### ${DateTime.now().millisecondsSinceEpoch} Creating widget WeListHome");
              widget = WeListHome();
            } else {
              print("#### ${DateTime.now().millisecondsSinceEpoch} Creating widget LoginScreen");
              widget = LoginScreen();
            }
            return widget;
          }),
      navigatorObservers: [TransitionRouteObserver()],
      routes: Routes.getRoutes(),
    );
  }
}

class WeListHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WorkspaceWidget()
//            children: <Widget>[WeListNewItem(), WeListView()],
      ;
}

// class WeListNewItem extends StatelessWidget {
//   final ObservableInput oInput = ObservableInput();
//   final TextEditingController controller = TextEditingController(text: "");
//
//   @override
//   Widget build(BuildContext context) {
//     final WeList weList = Provider.of(context);
//     return Observer(
//         builder: (context) => Container(
//             padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
//             margin: EdgeInsets.only(left: 20.0, right: 20.0),
//             child: TextField(
//                 autofocus: true,
//                 onChanged: (String value) {
//                   oInput.value = value;
//                 },
//                 onSubmitted: (_) {
//                   weList.add(WeListItem(oInput.input));
//                   oInput.value = "";
//                   controller.value = TextEditingValue(text: "empty");
//                 })));
//   }
// }
//
// class WeListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final WeList weList = Provider.of(context);
//     return Observer(
//         builder: (_) => Flexible(
//               child: ListView.builder(
//                   itemCount: weList.items.length,
//                   itemBuilder: (_, index) {
//                     WeListItem item = weList.items[index];
//                     return Observer(
//                         builder: (_) => Column(children: [
//                               CheckboxListTile(
//                                 controlAffinity: ListTileControlAffinity.leading,
//                                 value: item.completed,
//                                 onChanged: (bool newValue) => item.setState(newValue),
//                                 title: Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                         child: Text(
//                                       item.name,
//                                       overflow: TextOverflow.ellipsis,
//                                     )),
//                                     IconButton(icon: const Icon(Icons.delete), onPressed: () => weList.remove(item))
//                                   ],
//                                 ),
//                               ),
//                               Text(item.stateName, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis)
//                             ]));
//                   }),
//             ));
//   }
// }

class Routes {
  // Route name constants
  static const String splash = "/spash";
  static const String login = '/list';
  static const String list = '/detail';
  static const String createList = '/createList';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.splash: (context) => Splash(),
      Routes.login: (context) => LoginScreen(),
      Routes.list: (context) => WeListHome(),
      Routes.createList: (context) => CreateListContainerWidget()
    };
  }
}
