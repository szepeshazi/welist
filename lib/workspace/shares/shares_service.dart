import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../juiced/common/accessors.dart';
import '../../juiced/juiced.dart';
import '../../juiced/juiced.juicer.dart' as j;

part 'shares_service.g.dart';

class SharesService = _SharesService with _$SharesService;

abstract class _SharesService with Store {
  final ListContainer container;

  final FirebaseFirestore _fs;

  @observable
  List<DisplayShare> shares;

  _SharesService(this.container) : _fs = FirebaseFirestore.instance;

  Future<void> load() async {
    if (container == null) {
      shares = null;
      return;
    }
    List<DisplayShare> containerShares = [];
    List<DocumentReference> profileRefs = container.accessors[AccessorUtils.anyLevelKey].map((uid) => _fs.collection
      (PublicProfile.collectionName).doc(uid)).toList();
    List<Future<DocumentSnapshot>> profileFutures = [];
    List<DocumentSnapshot> profileSnapshots = [];
    for (var ref in profileRefs) {
      profileFutures.add(ref.get().then((value) { profileSnapshots.add(value); }));
    }
    await Future.wait(profileFutures);
    profileSnapshots.forEach((element) {print("###&&&### ${element.data()['email']}");});


    Map<String, DocumentSnapshot> profileMap = Map.fromIterable(profileSnapshots, key: (doc) => doc.reference.id);
    for (String level in container.accessors.keys) {
      if (level == AccessorUtils.anyLevelKey) continue;
      for (String uid in container.accessors[level]) {
        PublicProfile publicProfile = j.juicer.decode(profileMap[uid].data(), (_) => PublicProfile());
        containerShares.add(DisplayShare(publicProfile.email, ContainerAccess.labels[level]));
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
