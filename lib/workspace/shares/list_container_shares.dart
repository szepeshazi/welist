import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../juiced/common/accessors.dart';
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
        .where(FieldPath.documentId, whereIn: container.accessors[AccessorUtils.anyLevelKey])
        .get();
    for (var doc in sharesSnapshot.docs) {
      print("${doc.runtimeType}, ${doc.data()} ${doc.reference.id}");
    }
    Map<String, QueryDocumentSnapshot> userMap = Map.fromIterable(sharesSnapshot.docs, key: (doc) => doc.reference.id);
    for (String level in container.accessors.keys) {
      if (level == AccessorUtils.anyLevelKey) continue;
      for (String uid in container.accessors[level]) {
        User user = j.juicer.decode(userMap[uid].data(), (_) => User());
        containerShares.add(DisplayShare(user.email, ContainerAccess.labels[level]));
      }
    }
    shares = containerShares;
  }
}

class DisplayShare {
  final String email;

  final String role;

  const DisplayShare(this.email, this.role);
}
