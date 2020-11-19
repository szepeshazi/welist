import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../common/common.dart';

abstract class ServiceBase<T extends FirestoreEntity<HasAccessLog>> {
  FirebaseFirestore get fs;

  Future<void> upsert(T e, String userId, {DocumentReference parent, AccessAction action}) async {
    AccessAction logAction = action;
    if (logAction == null) {
      if (e.entity.accessLog.entries.isEmpty) {
        logAction = AccessAction.create;
      } else {
        logAction = AccessAction.update;
      }
    }
    dynamic encoded = j.juicer.encode(e);
    e.entity.log(userId, encoded, logAction);
    encoded[accessLogProperty] = j.juicer.encode(e.entity.accessLog);
    if (logAction == AccessAction.create) {
      CollectionReference collectionReference =
          parent == null ? fs.collection(e.entity.collection) : parent.collection(e.entity.collection);
      await collectionReference.add(encoded);
    } else {
      await e.reference.set(encoded);
    }
  }

  Future<void> updateFields(T e, String userId, Map<String, dynamic> updates) async {
    dynamic encoded = j.juicer.encode(e);
    e.entity.log(userId, encoded, AccessAction.update);
    updates[accessLogProperty] = j.juicer.encode(e.entity.accessLog);
    await e.reference.update(updates);
  }

  static const String accessLogProperty = "accessLog";
}

extension QueryExtras on Query {
  Query get notDeleted => where("accessLog.deleted", isEqualTo: false);

  Query hasAccess(String uid) => where("accessors.anyLevel", arrayContains: uid);
}
