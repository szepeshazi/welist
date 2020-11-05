import 'package:flutter/animation.dart';
import 'package:mobx/mobx.dart';

part 'splash.g.dart';

class Splash = _Splash with _$Splash;

abstract class _Splash with Store {
  Map<AnimationPart, AnimationController> controllers = {};

  @observable
  bool something = false;

  @action
  void setController(AnimationPart part, AnimationController controller) {
    controllers[part] = controller;
  }
}

enum AnimationPart { zoomImage, mainTextIn, subTextIn }
