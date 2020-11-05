import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/juicer.dart';

class ServiceBase {
  final Juicer juicer;

  ServiceBase(this.juicer);
}

extension QueryExtras on Query {
  Query get notDeleted => where("accessLog.deleted", isEqualTo: false);

  Query hasAccess(String uid) => where("accessors.anyLevel", arrayContains: uid);
}
