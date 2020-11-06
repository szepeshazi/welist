import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../auth/auth_service.dart';
import '../../juiced/common/accessors.dart';
import '../../juiced/juiced.dart';
import '../../juiced/juiced.juicer.dart' as j;
import '../../shared/service_base.dart';
import 'invite/invite_service.dart';
import 'shares_list.dart';

part 'shares_service.g.dart';

class SharesService = _SharesService with _$SharesService;

abstract class _SharesService with Store {
  final ListContainer container;

  final FirebaseFirestore _fs;

  final AuthService _authService;

  final InviteService _inviteService;

  @observable
  List<ShareListItem> shares;

  StreamSubscription<DocumentSnapshot> containerChangeListener;

  _SharesService(this.container, this._authService, this._inviteService) : _fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to authentication changes
    containerChangeListener = container.reference.snapshots().listen((update) => _containerUpdated(update));
  }

  Future<void> _containerUpdated(DocumentSnapshot snapshot) async {
    ListContainer updatedContainer = j.juicer.decode(snapshot.data(), (_) => ListContainer());
    List<String> accessorKeys = updatedContainer.accessors[AccessorUtils.anyLevelKey].cast<String>();
    List<PublicProfile> accessorProfiles = await _getAccessorProfiles(accessorKeys);
    List<ShareListItem> containerShares = [];
    Map<String, PublicProfile> accessorProfileMap =
        Map.fromIterable(accessorProfiles, key: (profile) => profile.reference.id);
    for (String level in updatedContainer.accessors.keys) {
      if (level == AccessorUtils.anyLevelKey) continue;
      for (String uid in updatedContainer.accessors[level]) {
        bool allowRemoveCallback = level != ContainerAccess.owners || updatedContainer.accessors[level].length > 1;
        containerShares.add(ShareItem(
            email: accessorProfileMap[uid].email,
            role: ContainerAccess.labels[level],
            removeCallback: allowRemoveCallback ? () async => await remove(updatedContainer, uid) : null));
      }
    }

    // Add list divider
    containerShares.add(SectionItem("Pending invitations"));

    List<Invitation> invitations = await _getInvitationsForContainer();
    //Map<String, PublicProfile> invitedProfileMap = Map.fromIterable(invitedProfiles, key: (profile) => profile.email);
    for (final invite in invitations) {
      containerShares.add(InviteItem(
          email: invite.recipientEmail,
          role: ContainerAccess.labels[invite.payload["accessLevel"]],
          invitedTime: invite.accessLog.timeCreated,
          revokeCallback: () async => await _inviteService.revoke(invite)));
    }
    shares = containerShares;
  }

  /// Remove accessor from current container
  Future<void> remove(ListContainer updatedContainer, String uid) async {
    for (final level in updatedContainer.accessors.keys) {
      updatedContainer.accessors[level].remove(uid);
    }
    dynamic encodedContainer = j.juicer.encode(updatedContainer);
    updatedContainer.log(_authService.user.reference.id, encodedContainer);
    encodedContainer["accessLog"] = j.juicer.encode(updatedContainer.accessLog);
    await container.reference.set(encodedContainer);
  }

  Future<List<Invitation>> _getInvitationsForContainer() async {
    QuerySnapshot invitesSnapshot = await _fs
        .collection(Invitation.collectionName)
        .notDeleted
        .where("subjectId", isEqualTo: container.reference.id)
        .where("senderUid", isEqualTo: _authService.user.reference.id)
        .get();
    List<Invitation> invitations = [];
    if (invitesSnapshot.docs.isNotEmpty) {
      for (final doc in invitesSnapshot.docs) {
        invitations.add(j.juicer.decode(doc.data(), (_) => Invitation()..reference = doc.reference));
      }
    }
    return invitations;
  }

  Future<List<PublicProfile>> _getAccessorProfiles(List<String> uids) async {
    List<DocumentReference> profileRefs =
        uids.map((uid) => _fs.collection(PublicProfile.collectionName).doc(uid)).toList();
    List<Future<DocumentSnapshot>> profileFutures = [];
    List<DocumentSnapshot> profileSnapshots = [];
    for (var ref in profileRefs) {
      profileFutures.add(ref.get().then((snapshot) {
        profileSnapshots.add(snapshot);
        return snapshot;
      }));
    }
    await Future.wait(profileFutures);
    return profileSnapshots.map(fromSnapshot).toList();
  }

  // Future<List<PublicProfile>> _getInvitedProfiles(List<String> emails) async {
  //   QuerySnapshot querySnapshot =
  //       await _fs.collection(PublicProfile.collectionName).where("email", whereIn: emails).get();
  //   print("getInvitedProfiles docs: ${querySnapshot.docs.length}");
  //   return querySnapshot.docs.map(fromSnapshot).toList();
  // }

  void cleanUp() {
    containerChangeListener?.cancel();
  }

  PublicProfile fromSnapshot(DocumentSnapshot snapshot) =>
      j.juicer.decode(snapshot.data(), (_) => PublicProfile()..reference = snapshot.reference);
}
