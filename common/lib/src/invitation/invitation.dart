import 'package:juicer/metadata.dart';

import '../access/access_log.dart';

@juiced
class Invitation with AccessLogUtils {
  @override
  @Property(ignore: true)
  dynamic dynamicReference;

  String senderUid;

  String senderEmail;

  String senderName;

  String recipientUid;

  String recipientEmail;

  String subjectId;

  Map<String, dynamic> payload;

  @override
  AccessLog accessLog;

  int recipientRespondedTime = 0;

  int recipientAcceptedTime = 0;

  int recipientRejectedTime = 0;

  @override
  String get collection => Invitation.collectionName;

  static const String collectionName = "invitations";
}
