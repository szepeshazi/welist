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
  //String uid = context.authUid;
  print("Request data: $data, ${data.runtimeType}");

  AcceptInvitationRequest request = j.juicer.decode(data, (_) => AcceptInvitationRequest());

  DocumentSnapshot inviteSnapshot = await fs.collection(Invitation.collectionName).document(request.invitationId).get();
  Invitation invitation =
      setFirestoreDocRef(j.juicer.decode(inviteSnapshot.data.toMap(), (_) => Invitation()), inviteSnapshot.reference);

  DocumentSnapshot containerSnapshot =
      await fs.collection(ListContainer.collectionName).document(invitation.subjectId).get();
  ListContainer container = setFirestoreDocRef(
      j.juicer.decode(containerSnapshot.data.toMap(), (_) => ListContainer()), containerSnapshot.reference);

  print(
      "Accepting invitation from ${invitation.senderEmail}  for  ${getFirestoreDocRef(container).documentID} at ${invitation.recipientAcceptedTime}");
  print("container ${container.name} ${container.type} ${container.itemCount}");

  AcceptInvitationResponse response = AcceptInvitationResponse()
    ..invitationId = request.invitationId
    ..error = ErrorResponse.accessDenied();

  return response;
}
