import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../main_page/main_page_navigator.dart';
import '../shared/animation_director/animation_director.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPageNavigator _mainPageNavigator = Provider.of(context);
    final AnimationDirector director = AnimationDirector();
    StreamSubscription directorListener;
    directorListener= director.completed.listen((bool completed) {
      if (completed) {
        _mainPageNavigator.updateSplashScreenStatus(false);
        directorListener.cancel();
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
              child: Text("We List", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4
                  .copyWith(color: Colors.black))),
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
