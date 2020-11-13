import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/juicer.dart';
import 'package:juicer/metadata.dart';

import '../shared/enum_codec.dart';
import '../access/access_log.dart';
import '../access/accessors.dart';

enum ContainerType { shopping, todo }

@juiced
class ListContainer with AccessLogUtils, AccessorUtils {
  @override
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

  void copyPropertiesFrom(ListContainer other) {
    name = other.name;
    itemCount = other.itemCount;
    type = other.type;
    accessLog = other.accessLog;
    accessors = other.accessors;
  }

  static const Map<ContainerType, String> containerTypeLabels = {
    ContainerType.shopping: "Shopping list",
    ContainerType.todo: "Todo list"
  };

  static Future<ListContainer> fromSnapshot(DocumentSnapshot snapshot, Juicer juicer) async {
    ListContainer container = juicer.decode(snapshot.data(), (_) => ListContainer()..reference = snapshot.reference);
    // TODO: accessor details should only be fetched when going to list sharing page
    return container;
  }

  @override
  String get collection => ListContainer.collectionName;

  static const String collectionName = "listContainers";

  // Property names
  static const String nameField = "name";
  static const String typeNameField = "typeName";
  static const String itemCountField = "itemCount";
  static const String accessorsField = "accessors";

  @override
  String toString() => "ListContainer(name: $name, type: $type)";
}

typedef FetchUserCallback = Future<DocumentSnapshot> Function(String userId);