import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: Column(children: [
          ElasticInRight(
              delay: Duration(milliseconds: 500),
              child: Text("We List", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline3)),
          Expanded(child: ZoomIn(child: Image(image: AssetImage('assets/images/checklist.jpg'))))
        ]),
        constraints: BoxConstraints.expand(),
      );
}
