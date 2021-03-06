import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../../../auth/auth_service.dart';
import '../../../shared/common.dart';
import '../../../shared/service_base.dart';

part 'invite_service.g.dart';

class InviteService = _InviteService with _$InviteService;

abstract class _InviteService extends ServiceBase<Invitation> with Store {
  @override
  final FirebaseFirestore fs;

  final AuthService _authService;

  @observable
  List<Invitation> sent = [];

  @observable
  List<Invitation> received = [];

  _InviteService(this._authService) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to invitation changes that were either sent or received by current user

    print("Checking invitations for _authService.user.email: ${_authService.user.email}");
    fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("recipientEmail", isEqualTo: _authService.user.email)
        .where("recipientRespondedTime", isEqualTo: 0)
        .snapshots()
        .listen(_handleReceivedUpdates);

    fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("senderUid", isEqualTo: _authService.user.reference.id)
        .where("recipientRespondedTime", isEqualTo: 0)
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
      ..recipientEmail = recipientEmail.trim()
      ..senderUid = _authService.user.reference.id
      ..senderEmail = _authService.user.email
      ..senderName = _authService.user.displayName
      ..subjectId = subjectUid
      ..payload = {"containerName": container.name, "containerType": container.typeName, "accessLevel": accessLevel};
    await upsert(invitation, _authService.user.reference.id, action: AccessAction.create);
  }

  Future<void> revoke(Invitation invitation) async {
    await upsert(invitation, _authService.user.reference.id, action: AccessAction.delete);
  }

  Future<void> accept(Invitation invitation) => _react(invitation, true);

  Future<void> reject(Invitation invitation) => _react(invitation, false);

  Future<void> _react(Invitation invitation, bool accept) async {
    HttpsCallable acceptInvitation =
        FirebaseFunctions.instanceFor(region: "europe-west2").httpsCallable('acceptInvitation');
    AcceptInvitationRequest request = AcceptInvitationRequest()
      ..invitationId = invitation.reference.id
      ..accept = accept;

    Map<String, dynamic> encoded = j.juicer.encode(request);
    encoded.forEach((key, value) {
      print("AcceptInvitationRequest key: $key (${key.runtimeType}), value: $value (${value.runtimeType})");
    });
    final result = await acceptInvitation(j.juicer.encode(request));
    AcceptInvitationResponse response = j.juicer.decode(result.data, (_) => AcceptInvitationResponse());
    print(
        "accept invitation response, id: ${response.invitationId}, error: ${response.error?.mnemonic}, ${response
            .error?.message} ${response.accepted ? 'accepted' : 'rejected'}");
  }
}
