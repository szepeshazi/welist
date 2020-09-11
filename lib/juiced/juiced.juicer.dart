// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JuiceGenerator
// **************************************************************************

import "package:welist/juiced/auth/user.dart" as jcr_i1;
import "package:welist/juiced/workspace/relation.dart" as jcr_i2;
import "package:welist/juiced/workspace/list_container.dart" as jcr_i3;
import 'package:juicer/juicer.dart';
export "package:welist/juiced/juiced.dart";

// package:welist/juiced/auth/user.dart User
// package:welist/juiced/workspace/relation.dart Relation
// package:welist/juiced/workspace/list_container.dart ListContainer
class _$UserJuicer extends ClassMapper<jcr_i1.User> {
  const _$UserJuicer();
  @override
  jcr_i1.User newInstance() => jcr_i1.User();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i1.User val) =>
      juicer.removeNullValues({
        "authId": val.authId,
        "displayName": val.displayName,
        "email": val.email,
      });
  @override
  jcr_i1.User fromMap(Juicer juicer, Map map, jcr_i1.User empty) {
    if (map.containsKey("authId")) empty.authId = map["authId"];
    if (map.containsKey("displayName")) empty.displayName = map["displayName"];
    if (map.containsKey("email")) empty.email = map["email"];
    return empty;
  }
}

class _$RelationJuicer extends ClassMapper<jcr_i2.Relation> {
  const _$RelationJuicer();
  @override
  jcr_i2.Relation newInstance() => jcr_i2.Relation();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i2.Relation val) =>
      juicer.removeNullValues({
        "userId": juicer.encode(val.userId),
        "relation": val.relation,
        "containerId": juicer.encode(val.containerId),
      });
  @override
  jcr_i2.Relation fromMap(Juicer juicer, Map map, jcr_i2.Relation empty) {
    if (map.containsKey("userId"))
      empty.userId = juicer.decode(map["userId"], null);
    if (map.containsKey("relation")) empty.relation = map["relation"];
    if (map.containsKey("containerId"))
      empty.containerId = juicer.decode(map["containerId"], null);
    return empty;
  }
}

class _$ListContainerJuicer extends ClassMapper<jcr_i3.ListContainer> {
  const _$ListContainerJuicer();
  @override
  jcr_i3.ListContainer newInstance() => jcr_i3.ListContainer();
  @override
  Map<String, dynamic> toMap(Juicer juicer, jcr_i3.ListContainer val) =>
      juicer.removeNullValues({
        "reference": juicer.encode(val.reference),
        "name": val.name,
        "timeCreated": val.timeCreated,
        "typeName": val.typeName,
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// type is ignored
// label is ignored
// icon is ignored
      });
  @override
  jcr_i3.ListContainer fromMap(
      Juicer juicer, Map map, jcr_i3.ListContainer empty) {
    if (map.containsKey("reference"))
      empty.reference = juicer.decode(map["reference"], null);
    if (map.containsKey("name")) empty.name = map["name"];
    if (map.containsKey("timeCreated"))
      empty.timeCreated = map["timeCreated"]?.toInt();
    if (map.containsKey("typeName")) empty.typeName = map["typeName"];
// containerTypeLabels is ignored
// _icons is ignored
// _defaultIcon is ignored
// type is ignored
// label is ignored
// icon is ignored
    return empty;
  }
}

const Juicer juicer = const Juicer(const {
  jcr_i1.User: const _$UserJuicer(),
  jcr_i2.Relation: const _$RelationJuicer(),
  jcr_i3.ListContainer: const _$ListContainerJuicer(),
});
