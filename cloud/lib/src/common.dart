import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:welist_common/common.dart';

extension FirestoreDocumentReference on  HasDocumentReference {
  DocumentReference get reference {
    assert (dynamicReference is DocumentReference);
    return dynamicReference;
  }

  set reference(DocumentReference newReference) => dynamicReference = newReference;
}
