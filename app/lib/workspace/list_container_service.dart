import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist_common/common.dart';
import 'package:welist_common/common.juicer.dart' as j;

import '../auth/auth_service.dart';
import '../shared/common.dart';
import '../shared/service_base.dart';

part 'list_container_service.g.dart';

class ListContainerService = _ListContainerService with _$ListContainerService;

abstract class _ListContainerService extends ServiceBase<ListContainer> with Store {
  @observable
  List<ListContainer> containers;

  @override
  final FirebaseFirestore fs;

  final AuthService _authService;

  StreamSubscription<QuerySnapshot> containerChangeListener;

  _ListContainerService(this._authService) : fs = FirebaseFirestore.instance;

  void initialize() {
    containerChangeListener = subscribeToContainerChanges();
  }

  StreamSubscription<QuerySnapshot> subscribeToContainerChanges() {
    // Listen to containers the current user has access to
    return fs
        .collection(ListContainer.collectionName)
        .notDeleted
        .hasAccess(_authService.user.reference.id)
        .snapshots()
        .listen((update) => _updateContainers(update));
  }

  Future<void> _updateContainers(QuerySnapshot update) async {
    List<ListContainer> _containers = [];
    for (var doc in update.docs) {
      ListContainer container = j.juicer.decode(doc.data(), (_) => ListContainer()..reference = doc.reference);
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
    await upsert(container, _authService.user.reference.id);
  }

  @action
  Future<void> delete(ListContainer container) async {
    await upsert(container, _authService.user.reference.id, action: AccessAction.delete);
  }

  void cleanUp() {
    containerChangeListener?.cancel();
  }
}
