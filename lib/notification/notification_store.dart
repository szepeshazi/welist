import 'package:mobx/mobx.dart';

import '../juiced/juiced.dart';
import '../shared/list_base/list_item_base.dart';
import '../workspace/shares/invite/invite_service.dart';
import 'notification_list.dart';

part 'notification_store.g.dart';

class NotificationStore = _NotificationStore with _$NotificationStore;

abstract class _NotificationStore with Store {
  final InviteService _inviteService;

  @observable
  List<ListItemBase> notifications = [];

  _NotificationStore(this._inviteService);

  Future<void> initialize() async {
    autorun((_) => notifications = _inviteService.received.map(fromInvitation).toList());
  }

  NotificationItem fromInvitation(Invitation invite) => NotificationItem(
      message: "Access ${invite.payload['containerName']} ${invite.payload['containerType']} list",
      from: invite.senderName ?? invite.senderEmail,
      role: ContainerAccess.labels[invite.payload["accessLevel"]],
      invitedTime: invite.accessLog.timeCreated,
      acceptCallback: () async => await _inviteService.accept(invite),
      rejectCallback: () async => await _inviteService.reject(invite));
}
