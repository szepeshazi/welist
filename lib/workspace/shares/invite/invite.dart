import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'invite.g.dart';

class Invite = _Invite with _$Invite;

abstract class _Invite with Store {

  final String senderUid;

  final String containerId;

  @observable
  String recipientEmail;

  @observable
  String accessLevel;

  _Invite({@required this.senderUid, @required this.containerId});

  @action
  void setRecipientEmail(String newValue) => recipientEmail = newValue;

  @action
  void setAccessLevel(String newValue) => accessLevel = newValue;
}
