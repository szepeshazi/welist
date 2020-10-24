
abstract class HasAccessors {
  Map<String, List<dynamic>> get accessors;

  set accessors(Map<String, List<dynamic>> newValue);
}

mixin AccessorUtils implements HasAccessors {

  void addAccessor(String uid, String level) {
    accessors ??= {};
    accessors[level] ??= [];
    accessors[level].add(uid);
    accessors[anyLevelKey] ??= [];
    accessors[anyLevelKey].add(uid);
  }

  void removeAccessor(String uid) {
    for (String key in accessors.keys) {
      accessors[key].remove(uid);
    }
  }

  static const String anyLevelKey = "anyLevel";
}