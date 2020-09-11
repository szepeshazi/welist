import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juicer/metadata.dart';

@juiced
class ListItem {
  DocumentReference reference;

  String name;

  int timeCreated;

  int timeCompleted;

  @Property(ignore: true)
  bool get completed => timeCompleted != null;

  @Property(ignore: true)
  String get stateName =>
      completed ? "Completed at ${DateTime.fromMillisecondsSinceEpoch(timeCompleted).toIso8601String()}" : "Open";

  @Property(ignore: true)
  Future<void> setState(bool state) async {
    int _timeCompleted = state ? DateTime.now().millisecondsSinceEpoch : null;
    await reference.update({"timeCompleted": _timeCompleted});
  }

  @override
  String toString() => "$name ($stateName)";
}
