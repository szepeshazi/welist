import 'package:juicer/metadata.dart';

@juiced
class User {
  String authId;

  String displayName;

  String email;

  @override
  String toString() => "User(authId: $authId, displayName: $displayName, email: $email)";
}
