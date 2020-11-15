import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';

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
  String uid = context.authUid;
  String invitationId = data['invitationId'];

  DocumentSnapshot inviteRef = await fs.collection("invitations").document(invitationId).get();
  Map<String, dynamic> inviteData = inviteRef.data.toMap();
  int accepted = inviteData["recipientAcceptedTime"];
  String containerId = inviteData["subjectId"];

  DocumentSnapshot containerRef = await fs.collection("listContainers").document(containerId).get();
  Map<String, dynamic> containerData = containerRef.data.toMap();

  print("Accepting invitation from ${inviteData['senderEmail']}  for  $containerId at $accepted");
  print("container ${containerData['name']} ${containerData['typeName']} ${containerData['itemCount']}");
}
