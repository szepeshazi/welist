import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import 'common.dart';

abstract class ServiceBase<T extends HasAccessLog> {
  FirebaseFirestore get fs;

  Future<void> upsert(T entity, String userId, {DocumentReference parent, AccessAction action}) async {
    AccessAction logAction = action;
    if (logAction == null) {
      if (entity.accessLog.entries.isEmpty) {
        logAction = AccessAction.create;
      } else {
        logAction = AccessAction.update;
      }
    }
    dynamic encoded = j.juicer.encode(entity);
    entity.log(userId, encoded, logAction);
    encoded[accessLogProperty] = j.juicer.encode(entity.accessLog);
    if (logAction == AccessAction.create) {
      CollectionReference collectionReference =
          parent == null ? fs.collection(entity.collection) : parent.collection(entity.collection);
      await collectionReference.add(encoded);
    } else {
      await getFirestoreDocRef(entity).set(encoded);
    }
  }

  Future<void> updateFields(T entity, String userId, Map<String, dynamic> updates) async {
    dynamic encoded = j.juicer.encode(entity);
    entity.log(userId, encoded, AccessAction.update);
    updates[accessLogProperty] = j.juicer.encode(entity.accessLog);
    await getFirestoreDocRef(entity).update(updates);
  }

  static const String accessLogProperty = "accessLog";
}

extension QueryExtras on Query {
  Query get notDeleted => where("accessLog.deleted", isEqualTo: false);

  Query hasAccess(String uid) => where("accessors.anyLevel", arrayContains: uid);
}
