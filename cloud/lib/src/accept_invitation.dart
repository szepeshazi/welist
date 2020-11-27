import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import 'common.dart';
import 'service_base.dart';

Future<dynamic> acceptInvitation(dynamic data, CallableContext context) async {
  final app = FirebaseAdmin.instance.initializeApp();
  final fs = app.firestore();
  AcceptInvitationResponse response = AcceptInvitationResponse();
  String uid = context.authUid;
  Invitation invitation;
  InviteService service = InviteService(fs);

  AcceptInvitationRequest request = j.juicer.decode(data, (_) => AcceptInvitationRequest());

  DocumentSnapshot userSnapshot = await fs.collection(User.collectionName).document(uid).get();
  User user = j.juicer.decode(userSnapshot.data.toMap(), (_) => User()..reference = userSnapshot.reference);

  DocumentSnapshot inviteSnapshot = await fs.collection(Invitation.collectionName).document(request.invitationId).get();
  if (!inviteSnapshot.exists) {
    // Trying to respond to non-existing invitation
    response.error = ErrorResponse.notFound(payload: {"invitationId": request.invitationId});
  } else {
    invitation =
        j.juicer.decode(inviteSnapshot.data.toMap(), (_) => Invitation()..reference = inviteSnapshot.reference);
    if (invitation.recipientEmail != user.email) {
      // Trying to respond to invitation that does not belong to current user
      response.error = ErrorResponse.accessDenied(payload: {"invitationId": request.invitationId});
    } else if (invitation.recipientRespondedTime != 0) {
      // This invitations has already been responded
      response.error = ErrorResponse.generic(
          mnemonic: "alreadyResponded",
          message: "This invitation was already responded to",
          payload: {"invitationId": request.invitationId});
    }
  }

  if (response.error != null) {
    return response;
  }

  final now = DateTime.now().millisecondsSinceEpoch;
  invitation.recipientRespondedTime = now;
  StringBuffer debugMessage = StringBuffer();

  if (request.accept) {
    debugMessage.write("Accepting ");
    response.accepted = true;
    invitation.recipientAcceptedTime = now;
  } else {
    debugMessage.write("Rejecting ");
    response.accepted = false;
    invitation.recipientRejectedTime = now;
  }
  await service.upsert(invitation, uid);
  debugMessage.writeln("invitation from ${invitation.senderEmail} at ${invitation.recipientRespondedTime}");

  if (request.accept) {
    ListContainerService containerService = ListContainerService(fs);
    DocumentSnapshot containerSnapshot =
        await fs.collection(ListContainer.collectionName).document(invitation.subjectId).get();
    ListContainer container = j.juicer
        .decode(containerSnapshot.data.toMap(), (_) => ListContainer()..reference = containerSnapshot.reference);

    debugMessage.writeln(
        "Adding ${user.email} (${user.reference.documentID}) to accessors as ${invitation.payload["accessLevel"]}");
    container.accessors[AccessorUtils.anyLevelKey].add(user.reference.documentID);
    container.accessors[invitation.payload["accessLevel"]] ??= <String>[];
    container.accessors[invitation.payload["accessLevel"]].add(user.reference.documentID);
    debugMessage.writeln("Updating container ${container.name} ${container.type} ${container.itemCount}");
    await containerService.upsert(container, uid);
  }

  print(debugMessage.toString());
  response.invitationId = request.invitationId;
  return j.juicer.encode(response);
}

class InviteService extends ServiceBase<Invitation> {
  @override
  final Firestore fs;

  InviteService(this.fs);
}

class ListContainerService extends ServiceBase<ListContainer> {
  @override
  final Firestore fs;

  ListContainerService(this.fs);
}
