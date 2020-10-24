import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:juicer/juicer.dart';
import 'package:juicer/metadata.dart';
import '../common/accessors.dart';

import '../../shared/enum_codec.dart';
import '../common/access_log.dart';
import '../juiced.dart';

enum ContainerType { shopping, todo }

@juiced
class ListContainer with AccessLogUtils, AccessorUtils {
  @Property(ignore: true)
  DocumentReference reference;

  String name;

  int itemCount;

  String typeName;

  @override
  AccessLog accessLog;

  @override
  Map<String, List<dynamic>> accessors;
  
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
  static const Map<ContainerType, String> containerTypeLabels = {
    ContainerType.shopping: "Shopping list",
    ContainerType.todo: "Todo list"
  };

  @Property(ignore: true)
  static const Map<ContainerType, Icon> _icons = {
    ContainerType.shopping: Icon(Icons.shopping_cart),
    ContainerType.todo: Icon(Icons.check_box)
  };

  static Future<ListContainer> fromSnapshot(DocumentSnapshot snapshot, Juicer juicer) async {
    ListContainer container = juicer.decode(snapshot.data(), (_) => ListContainer()..reference = snapshot.reference);
    // TODO: accessor details should only be fetched when going to list sharing page
    return container;
  }

  static const Icon _defaultIcon = Icon(Icons.not_interested);

  // Collection name
  static const collectionName = "listContainers";

  // Property names
  static const String nameField = "name";
  static const String typeNameField = "typeName";
  static const String itemCountField = "itemCount";
  static const String accessorsField = "accessors";

  @override
  String toString() => "ListContainer(name: $name, type: $type)";
}

typedef FetchUserCallback = Future<DocumentSnapshot> Function(String userId);
