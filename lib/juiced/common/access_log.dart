import 'dart:math';

import 'package:juicer/metadata.dart';

import '../../shared/enum_codec.dart';

enum AccessAction { create, update, delete }

@juiced
class AccessEntry {
  String userId;

  int timestamp;

  String actionName;

  AccessEntry();

  factory AccessEntry.now(String uid, AccessAction act, {int ts}) {
    return AccessEntry()
      ..userId = uid
      ..timestamp = ts ?? DateTime.now().millisecondsSinceEpoch
      ..action = act;
  }

  @Property(ignore: true)
  final EnumCodec<AccessAction> _accessActionCodec = EnumCodec(AccessAction.values);

  @Property(ignore: true)
  set action(AccessAction newValue) => actionName = _accessActionCodec.asString(newValue);

  @Property(ignore: true)
  AccessAction get action => _accessActionCodec.asEnum(actionName);
}

@juiced
class AccessLog {
  List<AccessEntry> entries = [];

  AccessEntry create;

  AccessEntry lastUpdate;

  static const int maxLogSize = 10;
}

abstract class HasAccessLog {
  AccessLog get accessLog;
}

mixin AccessLogUtils implements HasAccessLog {
  void log(AccessEntry entry) {
    int truncateAt = min(accessLog.entries.length, AccessLog.maxLogSize - 1);
    if (accessLog.entries.isEmpty) {
      if (entry.action != AccessAction.create) {
        throw StateError("First action on any object should be create, got ${entry.action}");
      } else {
        accessLog.create = entry;
      }
    } else {
      if (entry.action == AccessAction.create) {
        throw StateError("Only the first action should be create on any object, got ${entry.action}");
      } else {
        accessLog.lastUpdate = entry;
      }
    }
    accessLog.entries = accessLog.entries.sublist(0, truncateAt)..insert(0, entry);
  }

  List<AccessEntry> get logEntries => accessLog.entries;
}
