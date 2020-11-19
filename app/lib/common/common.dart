import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreEntity<T> {
  DocumentReference reference;

  T entity;

  FirestoreEntity(this.entity, this.reference);
}