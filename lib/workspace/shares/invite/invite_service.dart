import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../auth/auth_service.dart';
import '../../../juiced/common/access_log.dart';
import '../../../juiced/invitation/invitation.dart';
import '../../../juiced/juiced.dart';
import '../../../juiced/juiced.juicer.dart' as j;

part 'invite_service.g.dart';

class InviteService = _InviteService with _$InviteService;

abstract class _InviteService with Store {
  final FirebaseFirestore _fs;
  final AuthService _authService;

  @observable
  List<Invitation> invites = [];

  @computed
  List<Invitation> get sent => invites.where((invite) => invite.senderUid == _authService.user.reference.id);

  @computed
  List<Invitation> get received => invites.where((invite) => invite.senderUid == _authService.user.reference.id);

  _InviteService(this._authService) : _fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to invitation changes that were either sent or received by current user
    _fs.collection(Invitation.collectionName).snapshots().listen(_handleUpdates);
  }

  Future<void> _handleUpdates(QuerySnapshot updates) async {
    List<Invitation> _invites = List.from(invites);
    if (updates.docChanges.isNotEmpty) {
      for (var change in updates.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            Invitation invitation =
                j.juicer.decode(change.doc.data(), (_) => Invitation()..reference = change.doc.reference);
            _invites.add(invitation);
            break;
          case DocumentChangeType.modified:
            int index = invites.indexWhere((Invitation invite) => invite.reference.path == change.doc.reference.path);
            _invites[index] = j.juicer.decode(change.doc.data(), (_) => Invitation()..reference = change.doc.reference);
            break;
          case DocumentChangeType.removed:
            _invites.removeWhere((Invitation invite) => invite.reference.path == change.doc.reference.path);
            break;
        }
      }
    }
    invites = _invites;
  }

  Future<void> send({String recipientEmail, String subjectUid, String accessLevel}) async {
    Invitation invitation = Invitation()
      ..accessLog = AccessLog()
      ..recipientEmail = recipientEmail
      ..senderUid = _authService.user.reference.id
      ..subjectId = subjectUid
      ..payload = {"accessLevel": accessLevel};
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

  Future<void> accept(Invitation invitation) async {}
}
