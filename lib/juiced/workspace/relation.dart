import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

@juiced
class Relation {
  DocumentReference userId;

  String relation;

  DocumentReference containerId;

  @override
  String toString() => "Relation(userId: $userId, relation: $relation, containerId: $containerId)";
}
