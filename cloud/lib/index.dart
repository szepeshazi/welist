import 'package:cloud/common.dart';
import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

void main() {
  functions['helloWorld'] = functions.region('europe-west2').https.onRequest(helloWorld);
  functions['accept'] = functions.region('europe-west2').https.onCall(accept);
}

void helloWorld(ExpressHttpRequest request) {
  request.response.writeln('Hello world');
  final headersTxt = StringBuffer();
  request.headers.forEach((name, values) {
    headersTxt.writeAll([name, ':', ...values]);
    headersTxt.writeln();
  });
  request.response.write(headersTxt);
  request.response.close();
}

Future<void> accept(dynamic data, CallableContext context) async {
  final app = FirebaseAdmin.instance.initializeApp();
  final fs = app.firestore();
  //String uid = context.authUid;
  String invitationId = data['invitationId'];

  DocumentSnapshot inviteSnapshot = await fs.collection(Invitation.collectionName).document(invitationId).get();
  Invitation invitation =
      setFirestoreDocRef(j.juicer.decode(inviteSnapshot.data.toMap(), (_) => Invitation()), inviteSnapshot.reference);

  DocumentSnapshot containerSnapshot =
      await fs.collection(ListContainer.collectionName).document(invitation.subjectId).get();
  ListContainer container = setFirestoreDocRef(
      j.juicer.decode(containerSnapshot.data.toMap(), (_) => ListContainer()), containerSnapshot.reference);

  print(
      "Accepting invitation from ${invitation.senderEmail}  for  ${getFirestoreDocRef(container).documentID} at ${invitation.recipientAcceptedTime}");
  print("container ${container.name} ${container.type} ${container.itemCount}");
}
