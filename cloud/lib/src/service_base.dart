import 'dart:async';

import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import 'common.dart';

abstract class ServiceBase<T extends HasAccessLog> {
  Firestore get fs;

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
    DocumentData data = DocumentData.fromMap(encoded);
    if (logAction == AccessAction.create) {
      CollectionReference collectionReference =
          parent == null ? fs.collection(entity.collection) : parent.collection(entity.collection);
      await collectionReference.add(data);
    } else {
      await entity.reference.setData(data);
    }
  }

  Future<void> updateFields(T entity, String userId, Map<String, dynamic> updates) async {
    dynamic encoded = j.juicer.encode(entity);
    entity.log(userId, encoded, AccessAction.update);
    updates[accessLogProperty] = j.juicer.encode(entity.accessLog);
    await entity.reference.updateData(UpdateData.fromMap(updates));
  }

  static const String accessLogProperty = "accessLog";
}

extension QueryExtras on DocumentQuery {
  DocumentQuery get notDeleted => where("accessLog.deleted", isEqualTo: false);

  DocumentQuery hasAccess(String uid) => where("accessors.anyLevel", arrayContains: uid);
}
