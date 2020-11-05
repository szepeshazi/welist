import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// The base class for the different types of items the shares list can contain.
abstract class ShareListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class SectionItem implements ShareListItem {
  final String section;

  SectionItem(this.section);

  @override
  Widget buildTitle(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        color: Theme.of(context).accentColor,
        child: Text(section, style: Theme.of(context).textTheme.headline6.apply(
          color: Colors.white
        )));
  }

  @override
  Widget buildSubtitle(BuildContext context) => null;
}

class ShareItem implements ShareListItem {
  final String email;

  final String role;

  ShareItem(this.email, this.role);

  @override
  Widget buildTitle(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(children: [
            Container(padding: EdgeInsets.only(right: 5.0), child: Icon(Icons.account_circle)),
            Text("$email ($role)"),
          ]))
        ],
      );

  @override
  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class InviteItem implements ShareListItem {
  final String sender;
  final String body;

  InviteItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
