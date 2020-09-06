import 'package:juicer/metadata.dart';
import 'package:welist/juiced/juiced.dart';

@juiced
class ListContainer {
  String name;

  int timeCreated;

  String typeName;

  @Property(ignore: true)
  set type(ContainerType newValue) => typeName = containerName(newValue);

  @Property(ignore: true)
  ContainerType get type => containerTypeByName(typeName);

  @override
  String toString() => "ListContainer(name: $name, timeCreated: $timeCreated, type: $type)";
}

enum ContainerType {
  shopping,
  todo
}

const Map<ContainerType, String> containerTypeLabels = {
  ContainerType.shopping: "Shopping list",
  ContainerType.todo: "Todo list"
};

String containerName(ContainerType type) =>
    type
        .toString()
        .split('.')
        .last;

ContainerType containerTypeByName(String name) =>
    const <String, ContainerType>{"shopping": ContainerType.shopping, "todo": ContainerType
        .todo}[name];