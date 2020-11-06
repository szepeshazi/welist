import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../auth/auth_service.dart';
import '../../../juiced/common/access_log.dart';
import '../../../juiced/invitation/invitation.dart';
import '../../../juiced/juiced.dart';
import '../../../juiced/juiced.juicer.dart' as j;
import '../../../shared/service_base.dart';

part 'invite_service.g.dart';

class InviteService = _InviteService with _$InviteService;

abstract class _InviteService with Store {
  final FirebaseFirestore _fs;
  final AuthService _authService;

  @observable
  List<Invitation> sent = [];

  @observable
  List<Invitation> received = [];

  _InviteService(this._authService) : _fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to invitation changes that were either sent or received by current user
    _fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("recipientEmail", isEqualTo: _authService.user.email)
        .where("recipientResponded", isEqualTo: false)
        .snapshots()
        .listen(_handleReceivedUpdates);

    _fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("senderUid", isEqualTo: _authService.user.reference.id)
        .where("recipientResponded", isEqualTo: false)
        .snapshots()
        .listen(_handleSentUpdates);
  }

  Future<void> _handleReceivedUpdates(QuerySnapshot updates) async {
    received = await _handleUpdates(updates, received);
  }

  Future<void> _handleSentUpdates(QuerySnapshot updates) async {
    sent = await _handleUpdates(updates, sent);
  }

  Future<List<Invitation>> _handleUpdates(QuerySnapshot updates, List<Invitation> currentInvites) async {
    List<Invitation> updatedInvites = List.from(currentInvites);
    if (updates.docChanges.isNotEmpty) {
      for (var change in updates.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            Invitation invitation =
                j.juicer.decode(change.doc.data(), (_) => Invitation()..reference = change.doc.reference);
            updatedInvites.add(invitation);
            break;
          case DocumentChangeType.modified:
            int index =
                currentInvites.indexWhere((Invitation invite) => invite.reference.path == change.doc.reference.path);
            updatedInvites[index] =
                j.juicer.decode(change.doc.data(), (_) => Invitation()..reference = change.doc.reference);
            break;
          case DocumentChangeType.removed:
            updatedInvites.removeWhere((Invitation invite) => invite.reference.path == change.doc.reference.path);
            break;
        }
      }
    }
    return updatedInvites;
  }

  Future<void> send({ListContainer container, String recipientEmail, String subjectUid, String accessLevel}) async {
    Invitation invitation = Invitation()
      ..accessLog = AccessLog()
      ..recipientEmail = recipientEmail
      ..senderUid = _authService.user.reference.id
      ..senderEmail = _authService.user.email
      ..senderName = _authService.user.displayName
      ..subjectId = subjectUid
      ..payload = {"containerName": container.name, "containerType": container.typeName, "accessLevel": accessLevel};
    dynamic encoded = j.juicer.encode(invitation);
    invitation.log(_authService.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(invitation.accessLog);
    await _fs.collection(Invitation.collectionName).add(encoded);
  }

  Future<void> revoke(Invitation invitation) async {
    var encoded = j.juicer.encode(invitation);
    invitation.log(_authService.user.reference.id, encoded, deleteEntity: true);
    dynamic encodedAccess = j.juicer.encode(invitation.accessLog);
    await invitation.reference.update({"accessLog": encodedAccess});
  }

  Future<void> accept(Invitation invitation) => _acceptOrReject(invitation, true);

  Future<void> reject(Invitation invitation) => _acceptOrReject(invitation, false);

  Future<void> _acceptOrReject(Invitation invitation, bool accepted) async {
    if (accepted) {
      invitation.recipientAcceptedTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      invitation.recipientRejectedTime = DateTime.now().millisecondsSinceEpoch;
    }
    invitation.recipientResponded = true;
    dynamic encoded = j.juicer.encode(invitation);
    invitation.log(_authService.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(invitation.accessLog);
    await invitation.reference.set(encoded);
  }
}
