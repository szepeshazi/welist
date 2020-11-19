import 'package:juicer/metadata.dart';

@juiced
class PublicProfile {
  String displayName;

  String email;

  @override
  String toString() => "User(displayName: $displayName, email: $email)";

  static const collectionName = "publicProfiles";
}
