import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../auth/auth_service.dart';
import '../juiced/juiced.dart';
import '../juiced/juiced.juicer.dart' as j;
import '../shared/service_base.dart';

part 'list_container_service.g.dart';

class ListContainerService = _ListContainerService with _$ListContainerService;

abstract class _ListContainerService with Store {
  @observable
  List<ListContainer> containers;

  final FirebaseFirestore _fs;

  final AuthService _authService;

  StreamSubscription<QuerySnapshot> containerChangeListener;

  _ListContainerService(this._authService) : _fs = FirebaseFirestore.instance;

  void initialize() {
    containerChangeListener = subscribeToContainerChanges();
  }

  StreamSubscription<QuerySnapshot> subscribeToContainerChanges() {
    // Listen to containers the current user has access to
    return _fs
        .collection(ListContainer.collectionName)
        .notDeleted
        .hasAccess(_authService.user.reference.id)
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
      ..addAccessor(_authService.user.reference.id, ContainerAccess.owners);
    var encoded = j.juicer.encode(container);
    container.log(_authService.user.reference.id, encoded);
    encoded["accessLog"] = j.juicer.encode(container.accessLog);
    await _fs.collection(ListContainer.collectionName).add(encoded);
  }

  @action
  Future<void> delete(ListContainer container) async {
    var encoded = j.juicer.encode(container);
    container.log(_authService.user.reference.id, encoded, deleteEntity: true);
    dynamic encodedAccess = j.juicer.encode(container.accessLog);
    await container.reference.update({"accessLog": encodedAccess});
  }

  void cleanUp() {
    containerChangeListener?.cancel();
  }
}
