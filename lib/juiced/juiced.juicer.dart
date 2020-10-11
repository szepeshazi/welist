// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JuiceGenerator
// **************************************************************************

import "package:welist/juiced/auth/user.dart" as jcr_i1;
import "package:welist/juiced/workspace/relation.dart" as jcr_i2;
import "package:welist/juiced/workspace/list_container.dart" as jcr_i3;
import "package:welist/juiced/list_item/list_item.dart" as jcr_i4;
import "package:welist/juiced/common/access_log.dart" as jcr_i5;
import 'package:juicer/juicer.dart';
export "package:welist/juiced/juiced.dart";

// package:welist/juiced/auth/user.dart User
// package:welist/juiced/workspace/relation.dart Relation
// package:welist/juiced/workspace/list_container.dart ListContainer
// package:welist/juiced/list_item/list_item.dart ListItem
// package:welist/juiced/common/access_log.dart AccessEntry
// package:welist/juiced/common/access_log.dart ChangeSet
// package:welist/juiced/common/access_log.dart AccessLog
class _$UserJuicer extends ClassMapper<jcr_i1.User> {
  const _$UserJuicer();
  @override
  jcr_i1.User newInstance() => jcr_i1.User();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i1.User val) =>
      juicer.removeNullValues({
        "authId": val.authId,
        "displayName": val.displayName,
        "email": val.email,
      });
  @override
  jcr_i1.User fromMap(Juicer juicer, Map map, jcr_i1.User empty) {
    if (map.containsKey("authId")) empty.authId = map["authId"];
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
    return empty;
  }
}

class _$RelationJuicer extends ClassMapper<jcr_i2.Relation> {
  const _$RelationJuicer();
  @override
  jcr_i2.Relation newInstance() => jcr_i2.Relation();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i2.Relation val) =>
      juicer.removeNullValues({
        "userId": juicer.encode(val.userId),
        "relation": val.relation,
        "containerId": juicer.encode(val.containerId),
      });
  @override
  jcr_i2.Relation fromMap(Juicer juicer, Map map, jcr_i2.Relation empty) {
    if (map.containsKey("userId"))
      empty.userId = juicer.decode(map["userId"], null);
    if (map.containsKey("relation")) empty.relation = map["relation"];
    if (map.containsKey("containerId"))
      empty.containerId = juicer.decode(map["containerId"], null);
    return empty;
  }
}

class _$ListContainerJuicer extends ClassMapper<jcr_i3.ListContainer> {
  const _$ListContainerJuicer();
  @override
  jcr_i3.ListContainer newInstance() => jcr_i3.ListContainer();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i3.ListContainer val) =>
      juicer.removeNullValues({
        "reference": juicer.encode(val.reference),
        "name": val.name,
        "itemCount": val.itemCount,
        "typeName": val.typeName,
        "rawAccessors": val.rawAccessors?.map(juicer.encode)?.toList(),
        "accessLog": juicer.encode(val.accessLog),
// _containerTypeCodec is ignored
// accessors is ignored
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// type is ignored
// label is ignored
// icon is ignored
      });
  @override
  jcr_i3.ListContainer fromMap(
      Juicer juicer, Map map, jcr_i3.ListContainer empty) {
    if (map.containsKey("reference"))
      empty.reference = juicer.decode(map["reference"], null);
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("itemCount"))
      empty.itemCount = map["itemCount"]?.toInt();
    if (map.containsKey("typeName")) empty.typeName = map["typeName"];
    if (map.containsKey("rawAccessors"))
      empty.rawAccessors = juicer.decodeIterable(
              map["rawAccessors"], (dynamic val) => val as String, <String>[])
          as List<String>;
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i5.AccessLog());
// _containerTypeCodec is ignored
// accessors is ignored
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// type is ignored
// label is ignored
// icon is ignored
    return empty;
  }
}

class _$ListItemJuicer extends ClassMapper<jcr_i4.ListItem> {
  const _$ListItemJuicer();
  @override
  jcr_i4.ListItem newInstance() => jcr_i4.ListItem();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i4.ListItem val) =>
      juicer.removeNullValues({
// reference is ignored
        "name": val.name,
        "timeCompleted": val.timeCompleted,
        "accessLog": juicer.encode(val.accessLog),
// completed is ignored
// stateName is ignored
      });
  @override
  jcr_i4.ListItem fromMap(Juicer juicer, Map map, jcr_i4.ListItem empty) {
// reference is ignored
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("timeCompleted"))
      empty.timeCompleted = map["timeCompleted"]?.toInt();
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i5.AccessLog());
// completed is ignored
// stateName is ignored
    return empty;
  }
}

class _$AccessEntryJuicer extends ClassMapper<jcr_i5.AccessEntry> {
  const _$AccessEntryJuicer();
  @override
  jcr_i5.AccessEntry newInstance() => jcr_i5.AccessEntry();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i5.AccessEntry val) =>
      juicer.removeNullValues({
        "userId": val.userId,
        "timestamp": val.timestamp,
        "actionName": val.actionName,
        "changeSet": juicer.encode(val.changeSet),
        "lastFlattenedProperties": val.lastFlattenedProperties == null
            ? null
            : Map.fromIterable(val.lastFlattenedProperties.keys,
                value: (k) => juicer.encode(val.lastFlattenedProperties[k])),
// _accessActionCodec is ignored
// action is ignored
      });
  @override
  jcr_i5.AccessEntry fromMap(Juicer juicer, Map map, jcr_i5.AccessEntry empty) {
    if (map.containsKey("userId")) empty.userId = map["userId"];
    if (map.containsKey("timestamp"))
      empty.timestamp = map["timestamp"]?.toInt();
    if (map.containsKey("actionName")) empty.actionName = map["actionName"];
    if (map.containsKey("changeSet"))
      empty.changeSet =
          juicer.decode(map["changeSet"], (_) => jcr_i5.ChangeSet());
    if (map.containsKey("lastFlattenedProperties"))
      empty.lastFlattenedProperties = juicer.decodeMap(
              map["lastFlattenedProperties"], null, <String, dynamic>{})
          as Map<String, dynamic>;
// _accessActionCodec is ignored
// action is ignored
    return empty;
  }
}

class _$ChangeSetJuicer extends ClassMapper<jcr_i5.ChangeSet> {
  const _$ChangeSetJuicer();
  @override
  jcr_i5.ChangeSet newInstance() => jcr_i5.ChangeSet();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i5.ChangeSet val) =>
      juicer.removeNullValues({
        "deletedProperties":
            val.deletedProperties?.map(juicer.encode)?.toList(),
        "addedProperties": val.addedProperties == null
            ? null
            : Map.fromIterable(val.addedProperties.keys,
                value: (k) => juicer.encode(val.addedProperties[k])),
        "updatedProperties": val.updatedProperties == null
            ? null
            : Map.fromIterable(val.updatedProperties.keys,
                value: (k) => juicer.encode(val.updatedProperties[k])),
      });
  @override
  jcr_i5.ChangeSet fromMap(Juicer juicer, Map map, jcr_i5.ChangeSet empty) {
    if (map.containsKey("deletedProperties"))
      empty.deletedProperties = juicer.decodeIterable(map["deletedProperties"],
          (dynamic val) => val as String, <String>[]) as List<String>;
    if (map.containsKey("addedProperties"))
      empty.addedProperties =
          juicer.decodeMap(map["addedProperties"], null, <String, dynamic>{})
              as Map<String, dynamic>;
    if (map.containsKey("updatedProperties"))
      empty.updatedProperties =
          juicer.decodeMap(map["updatedProperties"], null, <String, dynamic>{})
              as Map<String, dynamic>;
    return empty;
  }
}

class _$AccessLogJuicer extends ClassMapper<jcr_i5.AccessLog> {
  const _$AccessLogJuicer();
  @override
  jcr_i5.AccessLog newInstance() => jcr_i5.AccessLog();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i5.AccessLog val) =>
      juicer.removeNullValues({
        "entries": val.entries?.map(juicer.encode)?.toList(),
        "create": juicer.encode(val.create),
// maxLogSize is ignored
        "timeCreated": val.timeCreated,
        "timeUpdated": val.timeUpdated,
      });
  @override
  jcr_i5.AccessLog fromMap(Juicer juicer, Map map, jcr_i5.AccessLog empty) {
    if (map.containsKey("entries"))
      empty.entries = juicer.decodeIterable(
          map["entries"],
          (_) => jcr_i5.AccessEntry(),
          <jcr_i5.AccessEntry>[]) as List<jcr_i5.AccessEntry>;
    if (map.containsKey("create"))
      empty.create = juicer.decode(map["create"], (_) => jcr_i5.AccessEntry());
// maxLogSize is ignored
// timeCreated is ignored
// timeUpdated is ignored
    return empty;
  }
}

const Juicer juicer = const Juicer(const {
  jcr_i1.User: const _$UserJuicer(),
  jcr_i2.Relation: const _$RelationJuicer(),
  jcr_i3.ListContainer: const _$ListContainerJuicer(),
  jcr_i4.ListItem: const _$ListItemJuicer(),
  jcr_i5.AccessEntry: const _$AccessEntryJuicer(),
  jcr_i5.ChangeSet: const _$ChangeSetJuicer(),
  jcr_i5.AccessLog: const _$AccessLogJuicer(),
});
