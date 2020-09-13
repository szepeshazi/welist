import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:juicer/metadata.dart';

import '../juiced.dart';

@juiced
class ListContainer {

  DocumentReference reference;

  String name;

  int timeCreated;

  int itemCount;

  String typeName;

  List<String> rawAccessors;

  @Property(ignore: true)
  set type(ContainerType newValue) => typeName = containerName(newValue);

  @Property(ignore: true)
  ContainerType get type => containerTypeByName(typeName);

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

  static const Icon _defaultIcon = Icon(Icons.not_interested);

  @override
  String toString() => "ListContainer(name: $name, timeCreated: $timeCreated, type: $type)";
}

class UserRole {
  final User user;
  final String role;

  UserRole(this.user, this.role);
}

enum ContainerType { shopping, todo }

String containerName(ContainerType type) => type.toString().split('.').last;

ContainerType containerTypeByName(String name) =>
    const <String, ContainerType>{"shopping": ContainerType.shopping, "todo": ContainerType.todo}[name];
