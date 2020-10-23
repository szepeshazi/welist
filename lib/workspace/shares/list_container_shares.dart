import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../juiced/juiced.dart';
import '../../juiced/juiced.juicer.dart' as j;

part 'list_container_shares.g.dart';

class ListContainerShares = _ListContainerShares with _$ListContainerShares;

abstract class _ListContainerShares with Store {
  final ListContainer container;

  final FirebaseFirestore _fs;

  @observable
  List<DisplayShare> shares;

  _ListContainerShares(this.container) : _fs = FirebaseFirestore.instance;

  Future<void> load() async {
    if (container == null) {
      shares = null;
      return;
    }
    List<DisplayShare> containerShares = [];
    QuerySnapshot sharesSnapshot = await _fs
        .collection(User.collectionName)
        .where(FieldPath.documentId, whereIn: container.accessors.anyLevel)
        .get();
    for (var doc in sharesSnapshot.docs) {
      print("${doc.runtimeType}, ${doc.data()} ${doc.reference.id}");
    }
    Map<String, QueryDocumentSnapshot> userMap = Map.fromIterable(sharesSnapshot.docs, key: (doc) => doc.reference.id);
    for (String uid in container.accessors.owners) {
      User user = j.juicer.decode(userMap[uid].data(), (_) => User());
      containerShares.add(DisplayShare(user.email, ContainerAccess.ownersField));
    }
    for (String uid in container.accessors.editors) {
      User user = j.juicer.decode(userMap[uid].data(), (_) => User());
      containerShares.add(DisplayShare(user.email, ContainerAccess.editorsField));
    }
    for (String uid in container.accessors.readers) {
      User user = j.juicer.decode(userMap[uid].data(), (_) => User());
      containerShares.add(DisplayShare(user.email, ContainerAccess.readersField));
    }
    shares = containerShares;
  }
}

class DisplayShare {
  final String email;

  final String role;

  const DisplayShare(this.email, this.role);
}
