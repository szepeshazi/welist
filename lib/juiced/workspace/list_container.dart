import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:juicer/juicer.dart';
import 'package:juicer/metadata.dart';

import '../../shared/enum_codec.dart';
import '../common/access_log.dart';
import '../juiced.dart';

enum ContainerType { shopping, todo }

@juiced
class ListContainer with AccessLogUtils {
  @Property(ignore: true)
  DocumentReference reference;

  String name;

  int itemCount;

  String typeName;

  List<String> rawAccessors;

  @override
  AccessLog accessLog;

  @Property(ignore: true)
  final EnumCodec<ContainerType> _containerTypeCodec = EnumCodec(ContainerType.values);

  @Property(ignore: true)
  set type(ContainerType newValue) => typeName = _containerTypeCodec.asString(newValue);

  @Property(ignore: true)
  ContainerType get type => _containerTypeCodec.asEnum(typeName);

  @Property(ignore: true)
  String get label => containerTypeLabels[type];

  @Property(ignore: true)
  Icon get icon => _icons[type] ?? _defaultIcon;

  @Property(ignore: true)
  List<UserRole> accessors;

  @Property(ignore: true)
  static const Map<ContainerType, String> containerTypeLabels = {
    ContainerType.shopping: "Shopping list",
    ContainerType.todo: "Todo list"
  };

  @Property(ignore: true)
  static const Map<ContainerType, Icon> _icons = {
    ContainerType.shopping: Icon(Icons.shopping_cart),
    ContainerType.todo: Icon(Icons.check_box)
  };

  static Future<ListContainer> fromSnapshot(
      DocumentSnapshot snapshot, Juicer juicer, FetchUserCallback fetchUserCallback) async {
    Map<String, UserRole> _userRoles = {};
    ListContainer container = juicer.decode(snapshot.data(), (_) => ListContainer()..reference = snapshot.reference);
    // TODO: accessor details should only be fetched when going to list sharing page
    container.accessors = [];
    for (String rawAccessor in container.rawAccessors) {
      List<String> rawAccessorParts = rawAccessor.split("::");
      UserRole userRole = _userRoles[rawAccessor];
      if (userRole == null) {
        String userId = rawAccessorParts[0];
        String role = rawAccessorParts[1];
        DocumentSnapshot userSnapshot = await fetchUserCallback(userId);
        User user = juicer.decode(userSnapshot.data(), (_) => User());
        userRole = UserRole(user, role);
        _userRoles[userId] = userRole;
      }
      container.accessors.add(userRole);
    }
    return container;
  }

  static const Icon _defaultIcon = Icon(Icons.not_interested);

  @override
  String toString() => "ListContainer(name: $name, type: $type)";
}

class UserRole {
  final User user;
  final String role;

  UserRole(this.user, this.role);
}

typedef FetchUserCallback = Future<DocumentSnapshot> Function(String userId);
