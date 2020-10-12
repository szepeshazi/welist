import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../juiced/juiced.dart';
import '../login_ui/login_screen.dart';
import '../navigation/main_page.dart';
import '../profile/user_info_widget.dart';
import '../splash/splash_widget.dart';
import '../view_list/view_list_widget.dart';
import '../workspace/workspace.dart';
import 'create_list_widget.dart';
import 'list_container_shares.dart';

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPage mainPage = Provider.of(context);
    return MultiProvider(
        providers: [Provider<Workspace>(create: (context) => Workspace(context.read<Auth>())..initialize())],
        child: Observer(
            builder: (context) => Navigator(
                    pages: [
                      if (mainPage.currentState == MainPageState.splashAnimation)
                        MaterialPage(key: ValueKey("splash"), name: "splash", child: SplashWidget()),
                      if (mainPage.currentState == MainPageState.loggedIn)
                        MaterialPage(key: ValueKey("workspace"), name: "workspace", child: MainScaffoldWidget()),
                      if (mainPage.currentState == MainPageState.loggedOut)
                        MaterialPage(key: ValueKey("login"), name: "login", child: LoginScreen()),
                      if (mainPage.showCreateListWidget)
                        MaterialPage(
                            key: ValueKey("createList"), name: "createList", child: CreateListContainerWidget()),
                      if (mainPage.selectedContainer != null)
                        MaterialPage(
                            key: ValueKey("viewList"),
                            name: "viewList",
                            child: ViewListWidget(container: mainPage.selectedContainer)),
                      if (mainPage.showSharesForContainer != null)
                        MaterialPage(
                            key: ValueKey("shares"),
                            name: "shares",
                            child: ListContainerSharesWidget(container: mainPage.showSharesForContainer)),
                    ],
                    onPopPage: (route, result) {
                      if (!route.didPop(result)) {
                        return false;
                      }
                      if (route.settings.name == "createList") {
                        mainPage.toggleCreateListWidget(false);
                      } else if (route.settings.name == "viewList") {
                        mainPage.selectContainer(null);
                      } else if (route.settings.name == "shares") {
                        mainPage.toggleSharesForContainer(null);
                      }
                      return true;
                    })));
  }
}

class MainScaffoldWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPage mainPage = Provider.of(context);
    return Scaffold(
        appBar: AppBar(title: Text("My lists"), actions: [UserInfoWidget()]),
        body: ListContainersWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              mainPage.toggleCreateListWidget(true);
            }));
  }
}

class ListContainersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    return Observer(
        builder: (context) => ListView.builder(
            padding: const EdgeInsets.only(left: 8),
            shrinkWrap: true,
            itemCount: workspace.containers?.length ?? 0,
            itemBuilder: (BuildContext context, index) =>
                ListContainerRowWidget(container: workspace.containers[index])));
  }
}

class ListContainerRowWidget extends StatelessWidget {
  final ListContainer container;

  const ListContainerRowWidget({Key key, this.container}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Workspace workspace = Provider.of(context);
    final MainPage mainPage = Provider.of(context);
    return ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Row(children: [
              Container(padding: EdgeInsets.only(right: 5.0), child: container.icon),
              Text(container.name),
              if ((container.itemCount ?? 0) > 0) Text(" (${container.itemCount})")
            ])),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                child: InkWell(
                  onTap: () => mainPage.toggleSharesForContainer(container),
                  child: Row(children: [Icon(Icons.people), Text("(1)")]),
                )),
          ],
        ),
        trailing: PopupMenuButton<ListContainerMenuItem>(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ListContainerMenuItem.delete,
                    child: Row(children: [
                      Container(padding: EdgeInsets.only(left: 10, right: 10), child: Text("Delete ${container.name}")),
                      Icon(Icons.delete)
                    ]),
                  )
                ],
            onSelected: (ListContainerMenuItem selected) {
              switch (selected) {
                case ListContainerMenuItem.delete:
                  workspace.delete(container);
                  break;
              }
            }),
        onTap: () {
          mainPage.selectContainer(container);
        });
  }
}

enum ListContainerMenuItem { delete }
