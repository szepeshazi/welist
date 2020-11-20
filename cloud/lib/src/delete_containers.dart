import 'package:firebase_functions_interop/firebase_functions_interop.dart';

Future<void> deleteContainers(ExpressHttpRequest request) async {
  final app = FirebaseAdmin.instance.initializeApp();
  final fs = app.firestore();


}
