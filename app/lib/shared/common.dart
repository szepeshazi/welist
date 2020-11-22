import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welist_common/common.dart';

typedef NotifyParent = void Function([dynamic payload]);

DocumentReference getFirestoreDocRef(HasDocumentReference entity) {
  if (entity.reference is DocumentReference) {
    return entity.reference;
  }
  return null;
}

HasDocumentReference setFirestoreDocRef(HasDocumentReference entity, DocumentReference reference) {
  entity.reference = reference;
  return entity;
}

extension DocRef on  HasDocumentReference {
  DocumentReference get reference => FirebaseFirestore.instance.doc(getFirestoreDocRef(this).path);
}