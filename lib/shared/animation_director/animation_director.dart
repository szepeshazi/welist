import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class AnimationDirector {
  final completeController = StreamController<bool>.broadcast();

  Stream<bool> get completed => completeController.stream;

  final Map<AnimationPart, AnimationController> _parts = {};

  ControllerCallback register(AnimationPart part, {bool setupComplete = false}) => (controller) {
        _parts[part] = controller;
        if (setupComplete) {
          for (AnimationPart part in _parts.keys) {
            _parts[part].addStatusListener((status) {
              for (AnimationPart dependent in _parts.keys) {
                if (dependent.dependsOn == part.id && dependent.trigger == status) {
                  if (dependent.delay != null) {
                    Future.delayed(dependent.delay).then((_) => _parts[dependent].forward());
                  } else {
                    _parts[dependent].forward();
                  }
                }
                if (status == AnimationStatus.completed) {
                  bool completed = _parts.values.where((ctrl) => ctrl.status != AnimationStatus.completed).isEmpty;
                  if (!completeController.isClosed) {
                    completeController.add(completed);
                  } if (completed) {
                    completeController.close();
                  }
                }
              }
            });
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

  void cleanUp() {
    completeController.close();
  }
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
