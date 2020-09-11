import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElasticInRight(
            delay: Duration(milliseconds: 600),
            child: Text("We List", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4)),
        ZoomIn(child: Image(image: AssetImage('assets/images/checklist.jpg'))),
        JelloIn(
            delay: Duration(milliseconds: 1200),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("Universal, shared lists for everyonce",
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2)))
      ]));
}
