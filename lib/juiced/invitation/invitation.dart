import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

import '../common/access_log.dart';

@juiced
class Invitation with AccessLogUtils {
  @override
  @Property(ignore: true)
  DocumentReference reference;

  String senderUid;

  String senderEmail;

  String senderName;

  String recipientUid;

  String recipientEmail;

  String subjectId;

  Map<String, dynamic> payload;

  @override
  AccessLog accessLog;

  bool recipientResponded = false;

  int recipientAcceptedTime = 0;

  int recipientRejectedTime = 0;

  @override
  String get collection => Invitation.collectionName;

  static const String collectionName = "invitations";
}
