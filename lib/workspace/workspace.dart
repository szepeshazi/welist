import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../auth/auth.dart';
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
    return _fs
        .collection(ListContainer.collectionName)
        .notDeleted
        .hasAccess(auth.user.reference.id)
        .snapshots()
        .listen((update) => _updateContainers(update));
  }

  Future<void> _updateContainers(QuerySnapshot update) async {
    List<ListContainer> _containers = [];
    for (var doc in update.docs) {
      ListContainer container = await ListContainer.fromSnapshot(doc, j.juicer);
      _containers.add(container);
    }
    containers = _containers;
  }

  @action
  Future<void> add(ListContainer container) async {
    container
      ..itemCount = 0
      ..accessLog = AccessLog()
      ..addAccessor(auth.user.reference.id, ContainerAccess.owners);
    var encoded = j.juicer.encode(container);
    container.log(auth.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(container.accessLog);
    await _fs.collection(ListContainer.collectionName).add(encoded);
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
}
