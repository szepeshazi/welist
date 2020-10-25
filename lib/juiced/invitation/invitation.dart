import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

import '../common/access_log.dart';

@juiced
class Invitation with AccessLogUtils {

  @Property(ignore: true)
  DocumentReference reference;

  String senderUid;

  String recipientUid;

  String recipientEmail;

  String subjectId;

  Map<String, dynamic> payload;

  @override
  AccessLog accessLog;

  int recipientAcceptedTime = 0;

  int recipientRejectedTime = 0;

  static const String collectionName = "invitations";
}
