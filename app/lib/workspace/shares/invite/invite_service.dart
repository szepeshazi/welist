import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../../../auth/auth_service.dart';
import '../../../common/common.dart';
import '../../../shared/service_base.dart';

part 'invite_service.g.dart';

class InviteService = _InviteService with _$InviteService;

abstract class _InviteService extends ServiceBase<FirestoreEntity<Invitation>> with Store {
  @override
  final FirebaseFirestore fs;

  final AuthService _authService;

  @observable
  List<FirestoreEntity<Invitation>> sent = [];

  @observable
  List<FirestoreEntity<Invitation>> received = [];

  _InviteService(this._authService) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to invitation changes that were either sent or received by current user
    fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("recipientEmail", isEqualTo: _authService.user.entity.email)
        .where("recipientResponded", isEqualTo: false)
        .snapshots()
        .listen(_handleReceivedUpdates);

    fs
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

  Future<List<FirestoreEntity<Invitation>>> _handleUpdates(
      QuerySnapshot updates, List<FirestoreEntity<Invitation>> currentInvites) async {
    List<FirestoreEntity<Invitation>> updatedInvites = List.from(currentInvites);
    if (updates.docChanges.isNotEmpty) {
      for (var change in updates.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            Invitation invitation = j.juicer.decode(change.doc.data(), (_) => Invitation());
            updatedInvites.add(FirestoreEntity<Invitation>(invitation, change.doc.reference));
            break;
          case DocumentChangeType.modified:
            int index = currentInvites
                .indexWhere((FirestoreEntity<Invitation> invite) => invite.reference.path == change.doc.reference.path);
            updatedInvites[index] = FirestoreEntity<Invitation>(
                j.juicer.decode(change.doc.data(), (_) => Invitation()), change.doc.reference);
            break;
          case DocumentChangeType.removed:
            updatedInvites.removeWhere(
                (FirestoreEntity<Invitation> invite) => invite.reference.path == change.doc.reference.path);
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
      ..senderEmail = _authService.user.entity.email
      ..senderName = _authService.user.entity.displayName
      ..subjectId = subjectUid
      ..payload = {"containerName": container.name, "containerType": container.typeName, "accessLevel": accessLevel};

    await upsert(FirestoreEntity<Invitation>(invitation, null), _authService.user.reference.id, action: AccessAction
        .create);
  }

  Future<void> revoke(FirestoreEntity<Invitation> invitation) async {
    await upsert(invitation, _authService.user.reference.id, action: AccessAction.delete);
  }

  Future<void> accept(FirestoreEntity<Invitation> invitation) async {
    invitation.entity.recipientAcceptedTime = DateTime.now().millisecondsSinceEpoch;
    await upsert(invitation, _authService.user.reference.id);
    HttpsCallable addPrivilegesToContainer =
        FirebaseFunctions.instanceFor(region: "europe-west2").httpsCallable('accept');
    await addPrivilegesToContainer({"invitationId": invitation.reference.id});
  }

  Future<void> reject(FirestoreEntity<Invitation> invitation) async {
    invitation.entity.recipientRejectedTime = DateTime.now().millisecondsSinceEpoch;
    await upsert(invitation, _authService.user.reference.id);
  }
}
