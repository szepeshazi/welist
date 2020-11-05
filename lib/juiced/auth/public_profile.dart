import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

@juiced
class PublicProfile {
  @Property(ignore: true)
  DocumentReference reference;

  String displayName;

  String email;

  @override
  String toString() => "User(displayName: $displayName, email: $email)";

  static const collectionName = "publicProfiles";
}
