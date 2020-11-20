import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:welist_common/common.dart';


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
