import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import 'common.dart';

Future<dynamic> acceptInvitation(dynamic data, CallableContext context) async {
  AcceptInvitationResponse response = await respondToInvitation(data, context, true);
  return j.juicer.encode(response);
}

Future<dynamic> rejectInvitation(dynamic data, CallableContext context) async {
  AcceptInvitationResponse response = await respondToInvitation(data, context, false);
  return j.juicer.encode(response);
}

Future<AcceptInvitationResponse> respondToInvitation(dynamic data, CallableContext context, bool accepted) async {
  final app = FirebaseAdmin.instance.initializeApp();
  final fs = app.firestore();
  AcceptInvitationResponse response = AcceptInvitationResponse();
  String uid = context.authUid;
  Invitation invitation;

  AcceptInvitationRequest request = j.juicer.decode(data, (_) => AcceptInvitationRequest());

  DocumentSnapshot inviteSnapshot = await fs.collection(Invitation.collectionName).document(request.invitationId).get();
  if (!inviteSnapshot.exists) {
    // Trying to respond to non-existing invitation
    response.error = ErrorResponse.notFound(payload: {"invitationId": request.invitationId});
  } else  {
    invitation =
    j.juicer.decode(inviteSnapshot.data.toMap(), (_) => Invitation()..reference = inviteSnapshot.reference);
    if (invitation.recipientUid != uid) {
      // Trying to respond to invitation that does not belong to current user
      response.error = ErrorResponse.accessDenied(payload: {"invitationId": request.invitationId});
    } else   if (invitation.recipientRespondedTime != 0) {
      // This invitations has already been responded
      response.error = ErrorResponse.generic(
          mnemonic: "alreadyResponded",
          message: "This invitation was already responded to",
          payload: {"invitationId": request.invitationId});
    }
  }

  if (response.hasError) {
    return response;
  }

  DocumentSnapshot containerSnapshot =
      await fs.collection(ListContainer.collectionName).document(invitation.subjectId).get();
  ListContainer container =
      j.juicer.decode(containerSnapshot.data.toMap(), (_) => ListContainer()..reference = containerSnapshot.reference);

  print(
      "Accepting invitation from ${invitation.senderEmail}  for  ${container.reference.documentID} at ${invitation.recipientAcceptedTime}");
  print("container ${container.name} ${container.type} ${container.itemCount}");

  invitation.recipientAcceptedTime = DateTime.now().millisecondsSinceEpoch;
  await upsert(invitation, _authService.user.reference.id);


  response.invitationId = request.invitationId;
  return response;
}
