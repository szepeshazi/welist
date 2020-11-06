import 'package:mobx/mobx.dart';

import '../../auth/auth_service.dart';
import '../../juiced/juiced.dart';
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
  List<ShareListItem> sharesAndInvites = [];

  _SharesStore(this._container, AuthService authService, this._sharesService, this._inviteService)
      : userId = authService.user.reference.id;

  void initialize() {
    final dispose = mainContext.onReactionError((a, b) {
      print("$a, $b");
    });
    autorun((_) {
      List<Invitation> currentContainerInvites = _inviteService.sent.where((invite) =>
          invite.subjectId == _container.reference.id && invite.senderUid == userId).toList(growable: false);
      sharesAndInvites = [
        ..._sharesService.accessors.map(fromAccessorProfile),
        if (_inviteService.invites.isNotEmpty) divider,
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
