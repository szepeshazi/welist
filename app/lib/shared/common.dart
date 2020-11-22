import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welist_common/common.dart';

typedef NotifyParent = void Function([dynamic payload]);

extension FirestoreDocumentReference on  HasDocumentReference {
  DocumentReference get reference {
    assert (dynamicReference is DocumentReference);
    return dynamicReference;
  }

  set reference(DocumentReference newReference) => dynamicReference = newReference;
}