import 'package:juicer/metadata.dart';

import '../error_response/error_response.dart';

@juiced
class AcceptInvitationRequest {
  String invitationId;
}

@juiced
class AcceptInvitationResponse {
  ErrorResponse error;

  String invitationId;
}
