import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';

import '../../auth/auth_service.dart';
import '../../shared/common.dart';
import '../../shared/list_base/list_item_base.dart';
import 'accessor_profile.dart';
import 'invite/invite_service.dart';
import 'shares_list.dart';
import 'shares_service.dart';

part 'shares_store.g.dart';

class SharesStore = _SharesStore with _$SharesStore;

abstract class _SharesStore with Store {
  final ListContainer _container;

  final SharesService _sharesService;

  final InviteService _inviteService;

  final String userId;

  @observable
  List<ListItemBase> sharesAndInvites = [];

  _SharesStore(this._container, AuthService authService, this._sharesService, this._inviteService)
      : userId = getFirestoreDocRef(authService.user).id;

  void initialize() {
    mainContext.onReactionError((a, b) {
      print("$a, $b");
    });
    autorun((_) {
      List<Invitation> currentContainerInvites = _inviteService.sent
          .where((invite) => invite.subjectId == getFirestoreDocRef(_container).id && invite.senderUid == userId)
          .toList(growable: false);
      sharesAndInvites = [
        ..._sharesService.accessors.map(fromAccessorProfile),
        if (currentContainerInvites.isNotEmpty) divider,
        ...currentContainerInvites.map(fromInvitation)
      ];
    });
  }

  InviteItem fromInvitation(Invitation invite) => InviteItem(
      email: invite.recipientEmail,
      role: ContainerAccess.labels[invite.payload["accessLevel"]],
      invitedTime: invite.accessLog.timeCreated,
      revokeCallback: () async => await _inviteService.revoke(invite));

  ShareItem fromAccessorProfile(AccessorProfile accessorProfile, {bool allowRemoveCallback = true}) => ShareItem(
      email: accessorProfile.profile.email,
      role: accessorProfile.role,
      removeCallback: allowRemoveCallback ? () async => await _sharesService.remove(accessorProfile.uid) : null);

  static final SectionItem divider = SectionItem("Pending invitations");
}
