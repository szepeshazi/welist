import 'package:juicer/metadata.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../access/access_log.dart';

@juiced
class ListItem with AccessLogUtils {
  String name;

  int timeCompleted;

  @override
  AccessLog accessLog;

  @Property(ignore: true)
  bool get completed => timeCompleted != null;

  @Property(ignore: true)
  String get stateName =>
      completed ? "Completed ${timeago.format(DateTime.fromMillisecondsSinceEpoch(timeCompleted))}" : "Open";

  @Property(ignore: true)
  void setState(bool state) => timeCompleted = state ? DateTime.now().millisecondsSinceEpoch : null;

  @override
  String toString() => "$name ($stateName)";

  @override
  String get collection => ListItem.collectionName;

  static const String collectionName = "items";
}
