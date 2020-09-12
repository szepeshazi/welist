class Role {
  static List<String> attachRoles(String userDocumentPath) =>
      roles.map((role) => "$userDocumentPath::$role").toList(growable: false);

  static const List<String> roles = [reader, performer, editor, owner];

  static const String reader = "reader";
  static const String performer = "performer";
  static const String editor = "editor";
  static const String owner = "owner";
}
