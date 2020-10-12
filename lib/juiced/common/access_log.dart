import 'dart:math';

import 'package:juicer/metadata.dart';

import '../../shared/enum_codec.dart';
import 'utils.dart';

enum AccessAction { create, update, delete }

@juiced
class AccessEntry {
  String userId;

  int timestamp;

  String actionName;

  ChangeSet changeSet;

  AccessEntry();

  factory AccessEntry.now(String uid, AccessAction act, dynamic flattenedProperties, ChangeSet changes) {
    return AccessEntry()
      ..userId = uid
      ..timestamp = DateTime.now().millisecondsSinceEpoch
      ..action = act
      ..changeSet = changes;
  }

  @Property(ignore: true)
  final EnumCodec<AccessAction> _accessActionCodec = EnumCodec(AccessAction.values);

  @Property(ignore: true)
  set action(AccessAction newValue) => actionName = _accessActionCodec.asString(newValue);

  @Property(ignore: true)
  AccessAction get action => _accessActionCodec.asEnum(actionName);
}

@juiced
class ChangeSet {
  List<String> deletedProperties;

  Map<String, dynamic> addedProperties;

  Map<String, dynamic> updatedProperties;

  @override
  String toString() => "deleted: $deletedProperties, added: $addedProperties, updated: $updatedProperties";
}

@juiced
class AccessLog {
  List<AccessEntry> entries = [];

  AccessEntry create;

  Map<String, dynamic> lastFlattenedProperties;

  static const int maxLogSize = 10;

  int get timeCreated => create?.timestamp;

  int get timeUpdated => entries.isNotEmpty ? entries.first.timestamp : null;
}

abstract class HasAccessLog {
  AccessLog get accessLog;
}

mixin AccessLogUtils implements HasAccessLog {
  List<AccessEntry> get logEntries => accessLog.entries;

  void log(String userId, dynamic encoded, {bool deleteEntity = false}) {
    AccessAction action;
    if (deleteEntity) {
      action = AccessAction.delete;
    } else if (accessLog.entries.isEmpty) {
      action = AccessAction.create;
    } else {
      action = AccessAction.update;
    }

    ChangeSet changeSet;
    Map<String, dynamic> flattenedProperties = flatten(encoded..remove("accessLog"));
    if (accessLog.entries.isEmpty) {
      changeSet = ChangeSet()..addedProperties = flattenedProperties;
    } else {
      changeSet = _trackChanges(accessLog.lastFlattenedProperties, flattenedProperties);
    }

    final entry = AccessEntry.now(userId, action, flattenedProperties, changeSet);

    int truncateAt = min(accessLog.entries.length, AccessLog.maxLogSize - 1);
    if (accessLog.entries.isEmpty) {
      accessLog.create = entry;
    }
    accessLog.entries = accessLog.entries.sublist(0, truncateAt)..insert(0, entry);
    accessLog.lastFlattenedProperties = flattenedProperties;
  }

  ChangeSet _trackChanges(Map<String, dynamic> prev, Map<String, dynamic> current) {
    ChangeSet result = ChangeSet();
    result.deletedProperties = prev.keys.where((key) => !current.containsKey(key)).toList();
    List<String> updatedKeys = prev.keys.where((key) => current.containsKey(key) && prev[key] != current[key]).toList();
    result.updatedProperties = Map.fromIterable(updatedKeys, value: (key) => current[key]);
    result.addedProperties =
        Map.fromIterable(current.keys.where((key) => !prev.containsKey(key)), value: (key) => current[key]);
    return result;
  }
}
