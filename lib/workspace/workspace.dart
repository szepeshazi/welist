import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist/juiced/auth/roles.dart';
import 'package:welist/juiced/juiced.dart';

import '../auth/auth.dart';
import '../juiced/juiced.juicer.dart' as j;

part 'workspace.g.dart';

class Workspace = _Workspace with _$Workspace;

abstract class _Workspace with Store {
  @observable
  List<ListContainer> containers;

  final FirebaseFirestore fs;

  final Auth auth;

  StreamSubscription<QuerySnapshot> containerChangeListener;

//   List<StreamSubscription<DocumentSnapshot>> containerChangeListeners;

  _Workspace(this.auth) : fs = FirebaseFirestore.instance;

  void initialize() {
    containerChangeListener = subscribeToContainerChanges();
  }

  StreamSubscription<QuerySnapshot> subscribeToContainerChanges() {
    // Listen to containers the current user has access to
    return fs
        .collection(collectionListContainers)
        .where('accessors', arrayContainsAny: Role.attachRoles(auth.userReference.path))
        .snapshots()
        .listen((update) => _updateContainer(update));
  }

  void _updateContainer(QuerySnapshot update) {
    List<ListContainer> _containers = [];
    for (var doc in update.docs) {
      _containers.add(j.juicer.decode(doc.data(), (_) => ListContainer()..reference = doc.reference));
    }
    containers = _containers;
  }

  @action
  Future<void> add(ListContainer container) async {
    container
      ..timeCreated = DateTime.now().millisecondsSinceEpoch
      ..itemCount = 0;
    DocumentReference containerRef = await fs.collection(collectionListContainers).add(j.juicer.encode(container));
    await containerRef.update({
      "accessors": FieldValue.arrayUnion(["${auth.userReference.path}::owner"])
    });
  }

  @action
  Future<void> delete(ListContainer container) async {
    // TODO: move this to cloud function
    // Remove access subcollection documents
    List<Future> accessDeleteOperations = [];
    QuerySnapshot accessCollectionSnapshot = await container.reference.collection(collectionContainerAccess).get();
    for (var access in accessCollectionSnapshot.docs) {
      accessDeleteOperations.add(access.reference.delete());
    }

    // TODO: move this to cloud function
    // Remove items subcollection documents
    List<Future> itemDeleteOperations = [];
    QuerySnapshot itemCollectionSnapshot = await container.reference.collection(collectionItems).get();
    for (var item in itemCollectionSnapshot.docs) {
      itemDeleteOperations.add(item.reference.delete());
    }

    // Wait for all subcollection delete operations
    await Future.wait(accessDeleteOperations);
    await Future.wait(itemDeleteOperations);

    await container.reference.delete();
  }

  void cleanUp() {
    containerChangeListener?.cancel();
  }

  static const String collectionListContainers = "containers";
  static const String collectionContainerAccess = "containerAccess";
  static const String collectionItems = "items";
}
