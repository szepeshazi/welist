import 'package:firebase_functions_interop/firebase_functions_interop.dart';

import 'src/accept_invitation.dart';
import 'src/delete_containers.dart';

void main() {
  functions['acceptInvitation'] = functions.region(region).https.onCall(acceptInvitation);
  functions['deleteContainers'] = functions.region(region).https.onRequest(deleteContainers);
}

const String region = 'europe-west2';