// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JuiceGenerator
// **************************************************************************

import "package:welist/juiced/auth/user.dart" as jcr_i1;
import "package:welist/juiced/auth/public_profile.dart" as jcr_i2;
import "package:welist/juiced/workspace/container_access.dart" as jcr_i3;
import "package:welist/juiced/workspace/list_container.dart" as jcr_i4;
import "package:welist/juiced/list_item/list_item.dart" as jcr_i5;
import "package:welist/juiced/common/access_log.dart" as jcr_i6;
import 'package:juicer/juicer.dart';
export "package:welist/juiced/juiced.dart";

// package:welist/juiced/auth/user.dart User
// package:welist/juiced/auth/public_profile.dart PublicProfile
// package:welist/juiced/workspace/container_access.dart ContainerAccess
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
// reference is ignored
        "displayName": val.displayName,
        "email": val.email,
// collectionName is ignored
      });
  @override
  jcr_i1.User fromMap(Juicer juicer, Map map, jcr_i1.User empty) {
// reference is ignored
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
// collectionName is ignored
    return empty;
  }
}

class _$PublicProfileJuicer extends ClassMapper<jcr_i2.PublicProfile> {
  const _$PublicProfileJuicer();
  @override
  jcr_i2.PublicProfile newInstance() => jcr_i2.PublicProfile();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i2.PublicProfile val) =>
      juicer.removeNullValues({
// reference is ignored
        "displayName": val.displayName,
        "email": val.email,
// collectionName is ignored
      });
  @override
  jcr_i2.PublicProfile fromMap(
      Juicer juicer, Map map, jcr_i2.PublicProfile empty) {
// reference is ignored
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
// collectionName is ignored
    return empty;
  }
}

class _$ContainerAccessJuicer extends ClassMapper<jcr_i3.ContainerAccess> {
  const _$ContainerAccessJuicer();
  @override
  jcr_i3.ContainerAccess newInstance() => jcr_i3.ContainerAccess();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i3.ContainerAccess val) =>
      juicer.removeNullValues({
        "anyLevel": val.anyLevel?.map(juicer.encode)?.toList(),
        "readers": val.readers?.map(juicer.encode)?.toList(),
        "performers": val.performers?.map(juicer.encode)?.toList(),
        "editors": val.editors?.map(juicer.encode)?.toList(),
        "owners": val.owners?.map(juicer.encode)?.toList(),
// anyLevelField is ignored
// readersField is ignored
// performersField is ignored
// editorsField is ignored
// ownersField is ignored
// accessLevels is ignored
      });
  @override
  jcr_i3.ContainerAccess fromMap(
      Juicer juicer, Map map, jcr_i3.ContainerAccess empty) {
    if (map.containsKey("anyLevel"))
      empty.anyLevel = juicer.decodeIterable(
              map["anyLevel"], (dynamic val) => val as String, <String>[])
          as List<String>;
    if (map.containsKey("readers"))
      empty.readers = juicer.decodeIterable(
              map["readers"], (dynamic val) => val as String, <String>[])
          as List<String>;
    if (map.containsKey("performers"))
      empty.performers = juicer.decodeIterable(
              map["performers"], (dynamic val) => val as String, <String>[])
          as List<String>;
    if (map.containsKey("editors"))
      empty.editors = juicer.decodeIterable(
              map["editors"], (dynamic val) => val as String, <String>[])
          as List<String>;
    if (map.containsKey("owners"))
      empty.owners = juicer.decodeIterable(
              map["owners"], (dynamic val) => val as String, <String>[])
          as List<String>;
// anyLevelField is ignored
// readersField is ignored
// performersField is ignored
// editorsField is ignored
// ownersField is ignored
// accessLevels is ignored
    return empty;
  }
}

class _$ListContainerJuicer extends ClassMapper<jcr_i4.ListContainer> {
  const _$ListContainerJuicer();
  @override
  jcr_i4.ListContainer newInstance() => jcr_i4.ListContainer();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i4.ListContainer val) =>
      juicer.removeNullValues({
// reference is ignored
        "name": val.name,
        "itemCount": val.itemCount,
        "typeName": val.typeName,
        "accessLog": juicer.encode(val.accessLog),
        "accessors": juicer.encode(val.accessors),
// _containerTypeCodec is ignored
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// collectionName is ignored
// nameField is ignored
// typeNameField is ignored
// itemCountField is ignored
// accessorsField is ignored
// type is ignored
// label is ignored
// icon is ignored
      });
  @override
  jcr_i4.ListContainer fromMap(
      Juicer juicer, Map map, jcr_i4.ListContainer empty) {
// reference is ignored
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("itemCount"))
      empty.itemCount = map["itemCount"]?.toInt();
    if (map.containsKey("typeName")) empty.typeName = map["typeName"];
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i6.AccessLog());
    if (map.containsKey("accessors"))
      empty.accessors =
          juicer.decode(map["accessors"], (_) => jcr_i3.ContainerAccess());
// _containerTypeCodec is ignored
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// collectionName is ignored
// nameField is ignored
// typeNameField is ignored
// itemCountField is ignored
// accessorsField is ignored
// type is ignored
// label is ignored
// icon is ignored
    return empty;
  }
}

class _$ListItemJuicer extends ClassMapper<jcr_i5.ListItem> {
  const _$ListItemJuicer();
  @override
  jcr_i5.ListItem newInstance() => jcr_i5.ListItem();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i5.ListItem val) =>
      juicer.removeNullValues({
// reference is ignored
        "name": val.name,
        "timeCompleted": val.timeCompleted,
        "accessLog": juicer.encode(val.accessLog),
// completed is ignored
// stateName is ignored
      });
  @override
  jcr_i5.ListItem fromMap(Juicer juicer, Map map, jcr_i5.ListItem empty) {
// reference is ignored
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("timeCompleted"))
      empty.timeCompleted = map["timeCompleted"]?.toInt();
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i6.AccessLog());
// completed is ignored
// stateName is ignored
    return empty;
  }
}

class _$AccessEntryJuicer extends ClassMapper<jcr_i6.AccessEntry> {
  const _$AccessEntryJuicer();
  @override
  jcr_i6.AccessEntry newInstance() => jcr_i6.AccessEntry();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i6.AccessEntry val) =>
      juicer.removeNullValues({
        "userId": val.userId,
        "timestamp": val.timestamp,
        "actionName": val.actionName,
        "changeSet": juicer.encode(val.changeSet),
// _accessActionCodec is ignored
// action is ignored
      });
  @override
  jcr_i6.AccessEntry fromMap(Juicer juicer, Map map, jcr_i6.AccessEntry empty) {
    if (map.containsKey("userId")) empty.userId = map["userId"];
    if (map.containsKey("timestamp"))
      empty.timestamp = map["timestamp"]?.toInt();
    if (map.containsKey("actionName")) empty.actionName = map["actionName"];
    if (map.containsKey("changeSet"))
      empty.changeSet =
          juicer.decode(map["changeSet"], (_) => jcr_i6.ChangeSet());
// _accessActionCodec is ignored
// action is ignored
    return empty;
  }
}

class _$ChangeSetJuicer extends ClassMapper<jcr_i6.ChangeSet> {
  const _$ChangeSetJuicer();
  @override
  jcr_i6.ChangeSet newInstance() => jcr_i6.ChangeSet();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i6.ChangeSet val) =>
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
  jcr_i6.ChangeSet fromMap(Juicer juicer, Map map, jcr_i6.ChangeSet empty) {
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

class _$AccessLogJuicer extends ClassMapper<jcr_i6.AccessLog> {
  const _$AccessLogJuicer();
  @override
  jcr_i6.AccessLog newInstance() => jcr_i6.AccessLog();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i6.AccessLog val) =>
      juicer.removeNullValues({
        "entries": val.entries?.map(juicer.encode)?.toList(),
        "create": juicer.encode(val.create),
        "lastFlattenedProperties": val.lastFlattenedProperties == null
            ? null
            : Map.fromIterable(val.lastFlattenedProperties.keys,
                value: (k) => juicer.encode(val.lastFlattenedProperties[k])),
// maxLogSize is ignored
// timeCreated is ignored
// timeUpdated is ignored
        "deleted": val.deleted,
      });
  @override
  jcr_i6.AccessLog fromMap(Juicer juicer, Map map, jcr_i6.AccessLog empty) {
    if (map.containsKey("entries"))
      empty.entries = juicer.decodeIterable(
          map["entries"],
          (_) => jcr_i6.AccessEntry(),
          <jcr_i6.AccessEntry>[]) as List<jcr_i6.AccessEntry>;
    if (map.containsKey("create"))
      empty.create = juicer.decode(map["create"], (_) => jcr_i6.AccessEntry());
    if (map.containsKey("lastFlattenedProperties"))
      empty.lastFlattenedProperties = juicer.decodeMap(
              map["lastFlattenedProperties"], null, <String, dynamic>{})
          as Map<String, dynamic>;
// maxLogSize is ignored
// timeCreated is ignored
// timeUpdated is ignored
// deleted is ignored
    return empty;
  }
}

const Juicer juicer = const Juicer(const {
  jcr_i1.User: const _$UserJuicer(),
  jcr_i2.PublicProfile: const _$PublicProfileJuicer(),
  jcr_i3.ContainerAccess: const _$ContainerAccessJuicer(),
  jcr_i4.ListContainer: const _$ListContainerJuicer(),
  jcr_i5.ListItem: const _$ListItemJuicer(),
  jcr_i6.AccessEntry: const _$AccessEntryJuicer(),
  jcr_i6.ChangeSet: const _$ChangeSetJuicer(),
  jcr_i6.AccessLog: const _$AccessLogJuicer(),
});
