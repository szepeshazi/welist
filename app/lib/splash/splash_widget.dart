import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../shared/animation_director/animation_director.dart';
import '../shared/common.dart';

class SplashWidget extends StatelessWidget {
  final NotifyParent _notifyParent;

  SplashWidget(this._notifyParent);

  @override
  Widget build(BuildContext context) {
    final director = AnimationDirector(3);
    StreamSubscription directorListener;
    directorListener = director.completed.listen((bool completed) {
      if (completed) {
        _notifyParent();
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
                  .register(AnimationConfig(id: titlePart, dependsOn: imagePart, trigger: AnimationEvent.complete)),
              child: Text("We List",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black))),
          ZoomIn(
              manualTrigger: true,
              animate: true,
              controller: director.register(AnimationConfig(id: imagePart, delay: Duration(milliseconds: 250))),
              child: Image(image: AssetImage('assets/images/checklist.jpg'))),
          JelloIn(
              manualTrigger: true,
              animate: false,
              controller: director.register(AnimationConfig(
                  id: subtitlePart,
                  dependsOn: titlePart,
                  trigger: AnimationEvent.start,
                  delay: Duration(milliseconds: 250))),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Universal, shared lists for everyone",
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2)))
        ]));
  }

  static const String imagePart = 'image';
  static const String titlePart = "title";
  static const String subtitlePart = "subtitle";
}
