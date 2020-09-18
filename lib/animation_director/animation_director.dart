
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class AnimationDirector {
  Map<AnimationPart, AnimationController> _parts = {};

  ControllerCallback register(AnimationPart part, {bool setupComplete = false}) => (controller) {
        _parts[part] = controller;
        print("Got $part, $controller");
        if (setupComplete) {
          for (AnimationPart part in _parts.keys) {
            print(part);
            _parts[part].addStatusListener((status) {
              print("animation: ${part.id} is $status");
              for (AnimationPart dependent in _parts.keys) {
                print("Checking potential dependent: ${dependent.id}, dependsOn: ${dependent.dependsOn}, trigger: "
                    "${dependent.trigger}");
                if (dependent.dependsOn == part.id && dependent.trigger == status) {
                  if (dependent.delay != null) {
                    Future.delayed(dependent.delay).then((_) => _parts[dependent].forward());
                  } else {
                    _parts[dependent].forward();
                  }
                }
            }});
            if (part.dependsOn == null) {
              if (part.delay != null) {
                Future.delayed(part.delay).then((_) => _parts[part].forward());
              } else {
                _parts[part].forward();
              }
            }
          }
        }
      };
}

class AnimationPart {
  final String id;

  final String dependsOn;

  final AnimationStatus trigger;

  final Duration delay;

  AnimationPart({@required this.id, this.dependsOn, this.trigger, this.delay});

  @override
  String toString() => "id: $id, dependsOn: $dependsOn, trigger: $trigger, delay: $delay";
}

typedef ControllerCallback = void Function(AnimationController);
