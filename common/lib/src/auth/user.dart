import 'package:juicer/metadata.dart';

import '../../common.dart';

@juiced
class User extends HasDocumentReference {
  @override
  @Property(ignore: true)
  dynamic reference;

  String displayName;

  String email;

  @override
  String toString() => "User(displayName: $displayName, email: $email)";

  static const collectionName = "users";
}
