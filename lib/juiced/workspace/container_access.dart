import 'package:juicer/metadata.dart';

@juiced
class ContainerAccess {
  List<String> anyLevel = [];
  List<String> readers = [];
  List<String> performers = [];
  List<String> editors = [];
  List<String> owners = [];

  static const String anyLevelField = "anyLevel";
  static const String readersField = "readers";
  static const String performersField = "performers";
  static const String editorsField = "editors";
  static const String ownersField = "owners";

  static const List<String> accessLevels = [readersField, performersField, editorsField, ownersField];
}
