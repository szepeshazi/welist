import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:welist_common/common.dart';

import '../../shared/list_base/list_item_base.dart';

class SectionItem implements ListItemBase {
  final String section;

  SectionItem(this.section);

  @override
  Widget buildTitle(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.deepOrange, width: 1))),
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Text(section,
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Colors.deepOrange)));
  }

  @override
  Widget buildSubtitle(BuildContext context) => null;

  @override
  Widget buildTrailing(BuildContext context) => null;
}

class ShareItem implements ListItemBase {
  final String email;

  final String role;

  final String userId;

  final ListContainer container;

  final InviteOperationCallback removeCallback;

  ShareItem(
      {@required this.email,
      this.role,
      this.removeCallback,
      this.userId,
      this.container});

  @override
  Widget buildTitle(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(children: [
            Container(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.account_circle)),
            Text(email),
          ]))
        ],
      );

  @override
  Widget buildSubtitle(BuildContext context) =>
      Container(margin: EdgeInsets.only(left: 30), child: Text(role));

  @override
  Widget buildTrailing(BuildContext context) => removeCallback == null
      ? null
      : IconButton(
          icon: const Icon(Icons.highlight_remove), onPressed: removeCallback);
}

/// A ListItem that contains data to display a message.
class InviteItem implements ListItemBase {
  final String email;

  final String role;

  final DateTime invitedDate;

  final InviteOperationCallback revokeCallback;

  InviteItem({this.email, this.role, int invitedTime, this.revokeCallback})
      : invitedDate = DateTime.fromMillisecondsSinceEpoch(invitedTime);

  @override
  Widget buildTitle(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(children: [
            Container(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.account_circle)),
            Text(email),
          ]))
        ],
      );

  @override
  Widget buildSubtitle(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30),
      child: Text("$role (sent: ${timeago.format(invitedDate)})"));

  @override
  Widget buildTrailing(BuildContext context) => IconButton(
      icon: const Icon(Icons.highlight_remove), onPressed: revokeCallback);
}

typedef InviteOperationCallback = Future<void> Function();
