import 'package:juicer/metadata.dart';

import '../error_response/error_response.dart';

@juiced
class AcceptInvitationRequest {
  String invitationId;

  /// If the invitation should be accepted or rejected
  /// `true`: accept
  /// `false`: reject
  bool accept;
}

@juiced
class AcceptInvitationResponse {
  ErrorResponse error;

  String invitationId;

  bool accepted;
}
