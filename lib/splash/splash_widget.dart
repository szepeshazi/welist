import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:welist/animation_director/animation_director.dart';
import 'package:welist/auth/auth.dart';
import 'package:welist/navigation/main_page.dart';

import '../main.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context);
    final MainPage mainPage  = Provider.of(context);
    final AnimationDirector director = AnimationDirector();
    director.completed.listen((event) {
      if (event) {
        if (auth.user != null) {
          mainPage.pushState(MainPageState.loggedIn);
        } else {
          mainPage.pushState(MainPageState.loggedOut);
        }
      }
    });
    return Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElasticInRight(
              manualTrigger: true,
              animate: false,
              controller: director
                  .register(AnimationPart(id: titlePart, dependsOn: imagePart, trigger: AnimationStatus.completed)),
              child: Text("We List", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4)),
          ZoomIn(
              manualTrigger: true,
              animate: true,
              controller: director.register(AnimationPart(id: imagePart, delay: Duration(milliseconds: 250))),
              child: Image(image: AssetImage('assets/images/checklist.jpg'))),
          JelloIn(
              manualTrigger: true,
              animate: false,
              controller: director.register(
                  AnimationPart(
                      id: subtitlePart,
                      dependsOn: titlePart,
                      trigger: AnimationStatus.forward,
                      delay: Duration(milliseconds: 250)),
                  setupComplete: true),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Universal, shared lists for everyonce",
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2)))
        ]));
  }

  static const String imagePart = 'image';
  static const String titlePart = "title";
  static const String subtitlePart = "subtitle";
}
