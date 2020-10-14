import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../auth/auth.dart';
import '../juiced/auth/roles.dart';
import '../juiced/juiced.dart';
import '../juiced/juiced.juicer.dart' as j;
import '../shared/service_base.dart';

part 'workspace.g.dart';

class Workspace = _Workspace with _$Workspace;

abstract class _Workspace with Store {
  @observable
  List<ListContainer> containers;

  final FirebaseFirestore _fs;

  final Auth auth;

  StreamSubscription<QuerySnapshot> containerChangeListener;

  _Workspace(this.auth) : _fs = FirebaseFirestore.instance;

  void initialize() {
    containerChangeListener = subscribeToContainerChanges();
  }

  StreamSubscription<QuerySnapshot> subscribeToContainerChanges() {
    // Listen to containers the current user has access to
    print("query condition: ${Role.attachRoles(auth.user.reference.id)}");
    return _fs
        .collection(collectionListContainers)
        .notDeleted
        .where('rawAccessors', arrayContainsAny: Role.attachRoles(auth.user.reference.id))
        .snapshots()
        .listen((update) => _updateContainers(update));
  }

  Future<void> _updateContainers(QuerySnapshot update) async {
    List<ListContainer> _containers = [];
    for (var doc in update.docs) {
      ListContainer container = await ListContainer.fromSnapshot(doc, j.juicer, fetchUserCallback);
      _containers.add(container);
    }
    containers = _containers;
  }

  @action
  Future<void> add(ListContainer container) async {
    container
      ..itemCount = 0
      ..accessLog = AccessLog()
      ..rawAccessors = ["${auth.user.reference.id}::owner"];
    var encoded = j.juicer.encode(container);
    container.log(auth.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(container.accessLog);
    await _fs.collection(collectionListContainers).add(encoded);
  }

  @action
  Future<void> delete(ListContainer container) async {
    var encoded = j.juicer.encode(container);
    container.log(auth.user.reference.id, encoded, deleteEntity: true);
    dynamic encodedAccess = j.juicer.encode(container.accessLog);
    await container.reference.update({"accessLog": encodedAccess});
  }

  void cleanUp() {
    containerChangeListener?.cancel();
  }

  static FetchUserCallback fetchUserCallback =
      (String userId) async => FirebaseFirestore.instance.collection("users").doc(userId).get();

  static const String collectionListContainers = "containers";
}
