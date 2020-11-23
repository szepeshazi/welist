import 'package:juicer/metadata.dart';

import '../error_response/error_response.dart';

@juiced
class AcceptInvitationRequest {
  String invitationId;
}

@juiced
mixin PossibleErrorResponse {
  ErrorResponse get error;

  set error(ErrorResponse actualError);

  bool get hasError => error != null;
}

@juiced
class AcceptInvitationResponse with PossibleErrorResponse {
  @override
  ErrorResponse error;

  String invitationId;
}
