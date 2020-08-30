import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:welist/observable_input_value/observable_input.dart';
import 'package:welist/we_list/we_list.dart';
import 'package:welist/we_list_item/we_list_item.dart';

import 'login_ui/login_screen.dart';
import 'login_ui/transition_route_observer.dart';

void main() => runApp(WeListApp());

class WeListApp extends StatelessWidget {
  final Future<FirebaseApp> _initialize = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeList',
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lime[500],
          accentColor: Colors.deepOrange[300]),
      home: FutureBuilder(
          future: _initialize,
          builder: (context, snapshot) {
            return LoginScreen();
          }),
      navigatorObservers: [TransitionRouteObserver()],
      routes: routes,
    );
  }
}

class WeListHome extends StatelessWidget {
  static const String routeName = "/WeList";

  @override
  Widget build(BuildContext context) => Provider<WeList>(
      create: (_) => WeList()..load(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Bevásárlás'),
          ),
          body: Column(
            children: <Widget>[WeListNewItem(), WeListView()],
          )));
}

class WeListNewItem extends StatelessWidget {
  final ObservableInput oInput = ObservableInput();
  final TextEditingController controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final WeList weList = Provider.of(context);
    return Observer(
        builder: (context) => Container(
            padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextField(
                autofocus: true,
                onChanged: (String value) {
                  oInput.value = value;
                },
                onSubmitted: (_) {
                  weList.add(WeListItem(oInput.input));
                  oInput.value = "";
                  controller.value = TextEditingValue(text: "empty");
                })));
  }
}

class WeListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeList weList = Provider.of(context);
    return Observer(
        builder: (_) => Flexible(
              child: ListView.builder(
                  itemCount: weList.items.length,
                  itemBuilder: (_, index) {
                    WeListItem item = weList.items[index];
                    return Observer(
                        builder: (_) => Column(children: [
                              CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                value: item.completed,
                                onChanged: (bool newValue) => item.setState(newValue),
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      item.name,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    IconButton(icon: const Icon(Icons.delete), onPressed: () => weList.remove(item))
                                  ],
                                ),
                              ),
                              Text(item.stateName, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis)
                            ]));
                  }),
            ));
  }
}

Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (BuildContext context) => LoginScreen(),
  WeListHome.routeName: (BuildContext context) => WeListHome(),
};
