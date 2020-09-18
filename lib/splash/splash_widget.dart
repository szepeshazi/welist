import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:welist/animation_director/animation_director.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AnimationDirector director = AnimationDirector();
    Widget widget = Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElasticInRight(
              manualTrigger: true,
              animate: false,
              controller: director
                  .register(AnimationPart(id: "main text", dependsOn: "image", trigger: AnimationStatus.completed)),
              child: Text("We List", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4)),
          ZoomIn(
              manualTrigger: true,
              animate: true,
              controller: director.register(AnimationPart(id: "image")),
              child: Image(image: AssetImage('assets/images/checklist.jpg'))),
          JelloIn(
              manualTrigger: true,
              animate: false,
              controller: director.register(
                  AnimationPart(id: "sub text", dependsOn: "image", trigger: AnimationStatus.completed),
                  setupComplete: true),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Universal, shared lists for everyonce",
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2)))
        ]));

    return widget;
  }
}
