import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class AnimationDirector {
  final completeController = StreamController<bool>.broadcast();

  Stream<bool> get completed => completeController.stream;

  final List<AnimationPart> _parts = [];

  final int sequenceLength;

  int sequenceCount;

  AnimationDirector(this.sequenceLength) : sequenceCount = 0;

  ControllerCallback register(AnimationConfig config) => (controller) {
        _parts.add(AnimationPart(config, controller));
        if (++sequenceCount == sequenceLength) {
          _buildSequence();
        }
      };

  void _buildSequence() {
    for (AnimationPart part in _parts) {
      part.events.listen((event) {
        _startDependents(part, event);
        if (event == AnimationEvent.complete) {
          bool completed = _parts.where((p) => !p.completed).isEmpty;
          if (!completeController.isClosed) {
            completeController.add(completed);
          }
          if (completed) {
            cleanUp();
          }
        }
      });
      if (part.config.dependsOn == null) {
        part.start();
      }
    }
  }

  void _startDependents(AnimationPart part, AnimationEvent event) {
    Iterable<AnimationPart> dependents =
        _parts.where((dep) => dep.config.dependsOn == part.config.id && dep.config.trigger == event);
    for (final dependent in dependents) {
      dependent.start();
    }
  }

  void cleanUp() {
    completeController.close();
  }
}

class AnimationConfig {
  final String id;

  final String dependsOn;

  final AnimationEvent trigger;

  final Duration delay;

  final RepeatCallback repeat;

  AnimationConfig({@required this.id, this.dependsOn, this.trigger = AnimationEvent.complete, this.delay, this.repeat});

  @override
  String toString() => "id: $id, dependsOn: $dependsOn, trigger: $trigger, delay: $delay";
}

class AnimationPart {
  final AnimationConfig config;

  final AnimationController _controller;

  final StreamController<AnimationEvent> eventController = StreamController.broadcast();

  Stream<AnimationEvent> get events => eventController.stream;

  int runCount = 0;

  bool completed = false;

  AnimationPart(this.config, this._controller) {
    if (_controller != null) {
      _controller.addStatusListener((status) {
        AnimationEvent event = eventMap[status];
        if (event != null) {
          eventController.add(event);
          if (event == AnimationEvent.complete) {
            _complete();
          }
        }
      });
    }
  }

  void start() {
    if (_controller != null) {
      Future.delayed(config.delay ?? _zeroDelay).then((_) => _controller.forward());
    } else {
      Future.delayed(config.delay ?? _zeroDelay).then((_) {
        _complete();
        eventController.add(AnimationEvent.complete);
      });
    }
  }

  void _complete() {
    runCount++;
    completed = true;
  }

  void reset() => _controller.reset();

  void cleanUp() => eventController.close();

  static Map<AnimationStatus, AnimationEvent> eventMap = {
    AnimationStatus.forward: AnimationEvent.start,
    AnimationStatus.completed: AnimationEvent.complete
  };

  static final Duration _zeroDelay = Duration(milliseconds: 0);
}

enum AnimationEvent { start, complete }

typedef ControllerCallback = void Function(AnimationController);

typedef RepeatCallback = bool Function(int runCount);
