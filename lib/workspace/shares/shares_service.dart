import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../auth/auth_service.dart';
import '../../juiced/common/accessors.dart';
import '../../juiced/juiced.dart';
import '../../juiced/juiced.juicer.dart' as j;
import '../../shared/service_base.dart';
import 'shares_list.dart';

part 'shares_service.g.dart';

class SharesService = _SharesService with _$SharesService;

abstract class _SharesService with Store {
  final ListContainer container;

  final FirebaseFirestore _fs;

  final AuthService _authService;

  @observable
  List<ShareListItem> shares;

  _SharesService(this.container, this._authService) : _fs = FirebaseFirestore.instance;

  Future<void> load() async {
    if (container == null) {
      shares = null;
      return;
    }

    List<ShareListItem> containerShares = [];

    List<String> accessorKeys = container.accessors[AccessorUtils.anyLevelKey].cast<String>();
    List<PublicProfile> accessorProfiles = await getAccessorProfiles(accessorKeys);

    List<Invitation> invitations = await getInvitationsForContainer();
    List<String> emails = invitations.map((invite) => invite.recipientEmail).toList();
    print("invited emails: $emails");
    List<PublicProfile> invitedProfiles = emails.isNotEmpty ? await getInvitedProfiles(emails) : [];

    Map<String, PublicProfile> profileMap = Map.fromIterable(accessorProfiles, key: (profile) => profile.reference.id);

    for (String level in container.accessors.keys) {
      if (level == AccessorUtils.anyLevelKey) continue;
      for (String uid in container.accessors[level]) {
        containerShares.add(ShareItem(profileMap[uid].email, ContainerAccess.labels[level]));
      }
    }
    containerShares.add(SectionItem("Pending invitations"));
    for (final profile in invitedProfiles) {
      containerShares.add(ShareItem(profile.email, "something"));
    }
    shares = containerShares;
  }

  Future<List<Invitation>> getInvitationsForContainer() async {
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

  Future<List<PublicProfile>> getAccessorProfiles(List<String> uids) async {
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

  Future<List<PublicProfile>> getInvitedProfiles(List<String> emails) async {
    QuerySnapshot querySnapshot =
        await _fs.collection(PublicProfile.collectionName).where("email", whereIn: emails).get();
    print("getInvitedProfiles docs: ${querySnapshot.docs.length}");
    return querySnapshot.docs.map(fromSnapshot).toList();
  }

  PublicProfile fromSnapshot(DocumentSnapshot snapshot) =>
      j.juicer.decode(snapshot.data(), (_) => PublicProfile()..reference = snapshot.reference);
}
