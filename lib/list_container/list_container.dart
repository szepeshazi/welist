import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../juiced/juiced.dart';

part 'list_container.g.dart';

class ListContainerStore = _ListContainer with _$ListContainerStore;

abstract class _ListContainer with Store {
  final String id;

  final String name;

  final ContainerType type;

  final DocumentReference reference;

  int createdAt;

  _ListContainer.fromMap(this.id, {Map<String, dynamic> data, this.reference})
      : assert(data['name'] != null),
        assert(data['createdAt'] != null),
        assert(data['type'] != null),
        name = data['name'],
        createdAt = data['createdAt'],
        type = data['type'] {
    print("Creating container $name, id: $id, type: $type");
  }

  _ListContainer.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.id, data: snapshot.data(), reference: snapshot.reference);

  @action
  Future<void> load() async {
    FirebaseFirestore.instance.collection('listContainers').snapshots().listen((event) {
//      containers = ObservableList.of(event.docs.map((e) => WeList.fromSnapshot(e)));
    });
  }

  @action
  void add(ListContainerStore container) {
    FirebaseFirestore.instance
        .collection('containers')
        .add({"name": container.name, "createdAt": container.createdAt, "type": container.type});
  }

  @action
  void remove(ListContainerStore container) {
    FirebaseFirestore.instance.collection('containers').doc(container.id).delete();
  }
}
