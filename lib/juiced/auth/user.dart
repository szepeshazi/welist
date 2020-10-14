import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

@juiced
class User {

  @Property(ignore: true)
  DocumentReference reference;

  String authId;

  String displayName;

  String email;

  @override
  String toString() => "User(authId: $authId, displayName: $displayName, email: $email)";
}
