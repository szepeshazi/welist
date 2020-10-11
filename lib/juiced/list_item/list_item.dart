import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

import '../common/access_log.dart';

@juiced
class ListItem with AccessLogUtils implements HasAccessLog {
  @Property(ignore: true)
  DocumentReference reference;

  String name;

  int timeCompleted;

  @override
  AccessLog accessLog;

  @Property(ignore: true)
  bool get completed => timeCompleted != null;

  @Property(ignore: true)
  String get stateName =>
      completed ? "Completed at ${DateTime.fromMillisecondsSinceEpoch(timeCompleted).toIso8601String()}" : "Open";

  @Property(ignore: true)
  void setState(bool state) => timeCompleted = state ? DateTime.now().millisecondsSinceEpoch : null;

  @override
  String toString() => "$name ($stateName)";
}
