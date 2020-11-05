import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../auth/auth.dart';
import '../../../juiced/common/access_log.dart';
import '../../../juiced/invitation/invitation.dart';
import '../../../juiced/juiced.juicer.dart' as j;

part 'invite_service.g.dart';

class InviteService = _InviteService with _$InviteService;

abstract class _InviteService with Store {
  final FirebaseFirestore _fs;
  final Auth _auth;

  @observable
  List<Invitation> sentInvitations;

  @observable
  List<Invitation> receivedInvitations;

  _InviteService(this._auth) : _fs = FirebaseFirestore.instance;

  Future<void> send({String recipientEmail, String subjectUid, String accessLevel}) async {
    Invitation invitation = Invitation()
      ..accessLog = AccessLog()
      ..recipientEmail = recipientEmail
      ..senderUid = _auth.user.reference.id
      ..subjectId = subjectUid
      ..payload = {"accessLevel": accessLevel};
    dynamic encoded = j.juicer.encode(invitation);
    invitation.log(_auth.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(invitation.accessLog);
    await _fs.collection(Invitation.collectionName).add(encoded);
  }
}