class ContainerAccess {
  static const String readers = "readers";
  static const String performers = "performers";
  static const String editors = "editors";
  static const String owners = "owners";

  static const List<String> levels = [readers, performers, editors, owners];

  static const Map<String, String> labels = {
    readers: "reader",
    performers: "performer",
    editors: "editor",
    owners: "owner"
  };
}
