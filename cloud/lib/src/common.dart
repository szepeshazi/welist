import 'package:firebase_admin_interop/firebase_admin_interop.dart';
import 'package:welist_common/common.dart';


DocumentReference getFirestoreDocRef(HasDocumentReference entity) {
  if (entity.dynamicReference is DocumentReference) {
    return entity.dynamicReference;
  }
  return null;
}

HasDocumentReference setFirestoreDocRef(HasDocumentReference entity, DocumentReference reference) {
  entity.dynamicReference = reference;
  return entity;
}
