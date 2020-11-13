import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../shared/list_base/list_item_base.dart';

/// A ListItem that contains data to display a message.
class NotificationItem implements ListItemBase {
  final String message;

  final String from;

  final String role;

  final DateTime invitedDate;

  final NotificationOperationCallback acceptCallback;

  final NotificationOperationCallback rejectCallback;

  NotificationItem({this.message, this.from, this.role, int invitedTime, this.acceptCallback, this.rejectCallback})
      : invitedDate = DateTime.fromMillisecondsSinceEpoch(invitedTime);

  @override
  Widget buildTitle(BuildContext context) => Row(mainAxisSize: MainAxisSize.max, children: [Text(message)]);

  @override
  Widget buildSubtitle(BuildContext context) =>
      Text("invited by $from to be $role\n(received: ${timeago.format(invitedDate)})");

  @override
  Widget buildTrailing(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: acceptCallback,
            icon: Icon(Icons.check),
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            color: Colors.green,
            padding: EdgeInsets.all(0),
            splashRadius: 25),
        IconButton(
            onPressed: rejectCallback,
            icon: Icon(Icons.remove_circle_outline),
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            color: Colors.red,
            padding: EdgeInsets.all(0),
            splashRadius: 25),
      ]);
}

typedef NotificationOperationCallback = Future<void> Function();
