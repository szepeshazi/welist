import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../../auth/auth_service.dart';
import '../../common/common.dart';
import '../../shared/service_base.dart';
import 'accessor_profile.dart';

part 'shares_service.g.dart';

class SharesService = _SharesService with _$SharesService;

abstract class _SharesService extends ServiceBase<FirestoreEntity<ListContainer>> with Store {
  final FirestoreEntity<ListContainer> container;

  @override
  final FirebaseFirestore fs;

  final AuthService _authService;

  @observable
  List<AccessorProfile> accessors = [];

  StreamSubscription<DocumentSnapshot> containerChangeListener;

  _SharesService(this.container, this._authService) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to authentication changes
    containerChangeListener = container.reference.snapshots().listen((update) => _containerUpdated(update));
  }

  Future<void> _containerUpdated(DocumentSnapshot snapshot) async {
    ListContainer updatedContainer = j.juicer.decode(snapshot.data(), (_) => ListContainer());
    container.entity.copyPropertiesFrom(updatedContainer);
    List<String> accessorKeys = container.entity.accessors[AccessorUtils.anyLevelKey].cast<String>();

    Map<String, AccessorProfile> accessorMap = Map.fromIterable(accessors, key: (accessor) => accessor.uid);
    List<AccessorProfile> _accessors = List.from(accessors);
    // Remove accessors that are not present any more in the container accessor list
    _accessors.removeWhere((accessor) => !accessorKeys.contains(accessor.uid));

    // Fetch public profiles for newly added accessors
    List<String> newAccessorKeys = accessorKeys.where((key) => !accessorMap.containsKey(key)).toList();
    if (newAccessorKeys.isNotEmpty) {
      List<PublicProfile> newAccessorProfiles = await _getAccessorProfiles(newAccessorKeys);
      Map<String, PublicProfile> profileMap =
          Map.fromIterable(newAccessorProfiles, key: (profile) => profile.reference.id);

      Iterable<String> levels = container.entity.accessors.keys.where((key) => key != AccessorUtils.anyLevelKey);
      for (final level in levels) {
        for (final uid in container.entity.accessors[level]) {
          if (!accessorMap.containsKey(uid)) {
            _accessors.add(AccessorProfile(level, FirestoreEntity<PublicProfile>(profileMap[uid], null)));
          }
        }
      }
    }
    accessors = _accessors;
  }

  /// Remove accessor from current container
  Future<void> remove(String uid) async {
    for (final level in container.entity.accessors.keys) {
      container.entity.accessors[level].remove(uid);
    }
    await upsert(container, _authService.user.reference.id);
  }

  Future<List<PublicProfile>> _getAccessorProfiles(List<String> uids) async {
    List<DocumentReference> profileRefs =
        uids.map((uid) => fs.collection(PublicProfile.collectionName).doc(uid)).toList();
    List<Future<DocumentSnapshot>> profileFutures = [];
    List<DocumentSnapshot> profileSnapshots = [];
    for (var ref in profileRefs) {
      profileFutures.add(ref.get().then((snapshot) {
        profileSnapshots.add(snapshot);
        return snapshot;
      }));
    }
    await Future.wait(profileFutures);
    return profileSnapshots.map(fromSnapshot).toList();
  }

  void cleanUp() {
    containerChangeListener?.cancel();
  }

  PublicProfile fromSnapshot(DocumentSnapshot snapshot) => j.juicer.decode(snapshot.data(), (_) => PublicProfile());
}
