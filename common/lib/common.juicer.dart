// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JuiceGenerator
// **************************************************************************

import "package:welist_common/src/access/access_log.dart" as jcr_i1;
import "package:welist_common/src/auth/public_profile.dart" as jcr_i2;
import "package:welist_common/src/auth/user.dart" as jcr_i3;
import "package:welist_common/src/invitation/invitation.dart" as jcr_i4;
import "package:welist_common/src/list_item/list_item.dart" as jcr_i5;
import "package:welist_common/src/workspace/list_container.dart" as jcr_i6;
import 'package:juicer/juicer.dart';
export "package:welist_common/common.dart";

// package:welist_common/src/access/access_log.dart AccessEntry
// package:welist_common/src/access/access_log.dart ChangeSet
// package:welist_common/src/access/access_log.dart AccessLog
// package:welist_common/src/auth/public_profile.dart PublicProfile
// package:welist_common/src/auth/user.dart User
// package:welist_common/src/invitation/invitation.dart Invitation
// package:welist_common/src/list_item/list_item.dart ListItem
// package:welist_common/src/workspace/list_container.dart ListContainer
class _$AccessEntryJuicer extends ClassMapper<jcr_i1.AccessEntry> {
  const _$AccessEntryJuicer();
  @override
  jcr_i1.AccessEntry newInstance() => jcr_i1.AccessEntry();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i1.AccessEntry val) =>
      juicer.removeNullValues({
        "userId": val.userId,
        "timestamp": val.timestamp,
        "actionName": val.actionName,
        "changeSet": juicer.encode(val.changeSet),
// _accessActionCodec is ignored
// action is ignored
      });
  @override
  jcr_i1.AccessEntry fromMap(Juicer juicer, Map map, jcr_i1.AccessEntry empty) {
    if (map.containsKey("userId")) empty.userId = map["userId"];
    if (map.containsKey("timestamp"))
      empty.timestamp = map["timestamp"]?.toInt();
    if (map.containsKey("actionName")) empty.actionName = map["actionName"];
    if (map.containsKey("changeSet"))
      empty.changeSet =
          juicer.decode(map["changeSet"], (_) => jcr_i1.ChangeSet());
// _accessActionCodec is ignored
// action is ignored
    return empty;
  }
}

class _$ChangeSetJuicer extends ClassMapper<jcr_i1.ChangeSet> {
  const _$ChangeSetJuicer();
  @override
  jcr_i1.ChangeSet newInstance() => jcr_i1.ChangeSet();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i1.ChangeSet val) =>
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
  jcr_i1.ChangeSet fromMap(Juicer juicer, Map map, jcr_i1.ChangeSet empty) {
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

class _$AccessLogJuicer extends ClassMapper<jcr_i1.AccessLog> {
  const _$AccessLogJuicer();
  @override
  jcr_i1.AccessLog newInstance() => jcr_i1.AccessLog();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i1.AccessLog val) =>
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
  jcr_i1.AccessLog fromMap(Juicer juicer, Map map, jcr_i1.AccessLog empty) {
    if (map.containsKey("entries"))
      empty.entries = juicer.decodeIterable(
          map["entries"],
          (_) => jcr_i1.AccessEntry(),
          <jcr_i1.AccessEntry>[]) as List<jcr_i1.AccessEntry>;
    if (map.containsKey("create"))
      empty.create = juicer.decode(map["create"], (_) => jcr_i1.AccessEntry());
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

class _$PublicProfileJuicer extends ClassMapper<jcr_i2.PublicProfile> {
  const _$PublicProfileJuicer();
  @override
  jcr_i2.PublicProfile newInstance() => jcr_i2.PublicProfile();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i2.PublicProfile val) =>
      juicer.removeNullValues({
        "displayName": val.displayName,
        "email": val.email,
// collectionName is ignored
      });
  @override
  jcr_i2.PublicProfile fromMap(
      Juicer juicer, Map map, jcr_i2.PublicProfile empty) {
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
// collectionName is ignored
    return empty;
  }
}

class _$UserJuicer extends ClassMapper<jcr_i3.User> {
  const _$UserJuicer();
  @override
  jcr_i3.User newInstance() => jcr_i3.User();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i3.User val) =>
      juicer.removeNullValues({
        "displayName": val.displayName,
        "email": val.email,
// collectionName is ignored
      });
  @override
  jcr_i3.User fromMap(Juicer juicer, Map map, jcr_i3.User empty) {
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
// collectionName is ignored
    return empty;
  }
}

class _$InvitationJuicer extends ClassMapper<jcr_i4.Invitation> {
  const _$InvitationJuicer();
  @override
  jcr_i4.Invitation newInstance() => jcr_i4.Invitation();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i4.Invitation val) =>
      juicer.removeNullValues({
        "senderUid": val.senderUid,
        "senderEmail": val.senderEmail,
        "senderName": val.senderName,
        "recipientUid": val.recipientUid,
        "recipientEmail": val.recipientEmail,
        "subjectId": val.subjectId,
        "payload": val.payload == null
            ? null
            : Map.fromIterable(val.payload.keys,
                value: (k) => juicer.encode(val.payload[k])),
        "accessLog": juicer.encode(val.accessLog),
        "recipientResponded": val.recipientResponded,
        "recipientAcceptedTime": val.recipientAcceptedTime,
        "recipientRejectedTime": val.recipientRejectedTime,
// collectionName is ignored
        "collection": val.collection,
      });
  @override
  jcr_i4.Invitation fromMap(Juicer juicer, Map map, jcr_i4.Invitation empty) {
    if (map.containsKey("senderUid")) empty.senderUid = map["senderUid"];
    if (map.containsKey("senderEmail")) empty.senderEmail = map["senderEmail"];
    if (map.containsKey("senderName")) empty.senderName = map["senderName"];
    if (map.containsKey("recipientUid"))
      empty.recipientUid = map["recipientUid"];
    if (map.containsKey("recipientEmail"))
      empty.recipientEmail = map["recipientEmail"];
    if (map.containsKey("subjectId")) empty.subjectId = map["subjectId"];
    if (map.containsKey("payload"))
      empty.payload =
          juicer.decodeMap(map["payload"], null, <String, dynamic>{})
              as Map<String, dynamic>;
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i1.AccessLog());
    if (map.containsKey("recipientResponded"))
      empty.recipientResponded = map["recipientResponded"];
    if (map.containsKey("recipientAcceptedTime"))
      empty.recipientAcceptedTime = map["recipientAcceptedTime"]?.toInt();
    if (map.containsKey("recipientRejectedTime"))
      empty.recipientRejectedTime = map["recipientRejectedTime"]?.toInt();
// collectionName is ignored
// collection is ignored
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
        "name": val.name,
        "timeCompleted": val.timeCompleted,
        "accessLog": juicer.encode(val.accessLog),
// collectionName is ignored
// completed is ignored
// stateName is ignored
        "collection": val.collection,
      });
  @override
  jcr_i5.ListItem fromMap(Juicer juicer, Map map, jcr_i5.ListItem empty) {
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("timeCompleted"))
      empty.timeCompleted = map["timeCompleted"]?.toInt();
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i1.AccessLog());
// collectionName is ignored
// completed is ignored
// stateName is ignored
// collection is ignored
    return empty;
  }
}

class _$ListContainerJuicer extends ClassMapper<jcr_i6.ListContainer> {
  const _$ListContainerJuicer();
  @override
  jcr_i6.ListContainer newInstance() => jcr_i6.ListContainer();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i6.ListContainer val) =>
      juicer.removeNullValues({
        "name": val.name,
        "itemCount": val.itemCount,
        "typeName": val.typeName,
        "accessLog": juicer.encode(val.accessLog),
        "accessors": val.accessors == null
            ? null
            : Map.fromIterable(val.accessors.keys,
                value: (k) => juicer.encode(val.accessors[k])),
// _containerTypeCodec is ignored
// containerTypeLabels is ignored
// collectionName is ignored
// nameField is ignored
// typeNameField is ignored
// itemCountField is ignored
// accessorsField is ignored
// type is ignored
// label is ignored
        "collection": val.collection,
      });
  @override
  jcr_i6.ListContainer fromMap(
      Juicer juicer, Map map, jcr_i6.ListContainer empty) {
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("itemCount"))
      empty.itemCount = map["itemCount"]?.toInt();
    if (map.containsKey("typeName")) empty.typeName = map["typeName"];
    if (map.containsKey("accessLog"))
      empty.accessLog =
          juicer.decode(map["accessLog"], (_) => jcr_i1.AccessLog());
    if (map.containsKey("accessors"))
      empty.accessors =
          juicer.decodeMap(map["accessors"], null, <String, List>{})
              as Map<String, List>;
// _containerTypeCodec is ignored
// containerTypeLabels is ignored
// collectionName is ignored
// nameField is ignored
// typeNameField is ignored
// itemCountField is ignored
// accessorsField is ignored
// type is ignored
// label is ignored
// collection is ignored
    return empty;
  }
}

const Juicer juicer = const Juicer(const {
  jcr_i1.AccessEntry: const _$AccessEntryJuicer(),
  jcr_i1.ChangeSet: const _$ChangeSetJuicer(),
  jcr_i1.AccessLog: const _$AccessLogJuicer(),
  jcr_i2.PublicProfile: const _$PublicProfileJuicer(),
  jcr_i3.User: const _$UserJuicer(),
  jcr_i4.Invitation: const _$InvitationJuicer(),
  jcr_i5.ListItem: const _$ListItemJuicer(),
  jcr_i6.ListContainer: const _$ListContainerJuicer(),
});
