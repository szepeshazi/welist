import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:welist/juiced/juiced.dart';

import '../auth/auth.dart';
import '../juiced/juiced.juicer.dart' as j;

part 'workspace.g.dart';

class Workspace = _Workspace with _$Workspace;

abstract class _Workspace with Store {
  @observable
  List<ListContainer> containers;

  @observable
  List<Relation> relations;

  final FirebaseFirestore fs;

  final Auth auth;

  StreamSubscription<QuerySnapshot> relationChangeListener;

  _Workspace(this.auth) : fs = FirebaseFirestore.instance;

  void initialize() {
    // Listen to authentication changes
    autorun((_) => _reset(auth.uiUser));
  }

  void _reset(dynamic _) {
    relationChangeListener?.cancel();
    relationChangeListener = subscribeToChanges(null);
  }

  StreamSubscription<QuerySnapshot> subscribeToChanges(dynamic _) {
    // Listen to relation record changes that affects current user
    return fs
        .collection("relations")
        .where('userId', isEqualTo: auth.userReference)
        .where('relation', whereIn: ['owner', 'editor', 'viewer'])
        .snapshots()
        .listen((update) => _updateWorkspace(update));
  }

  Future<void> _updateWorkspace(QuerySnapshot update) async {
    List<Relation> _relations = [];
    List<ListContainer> _containers = [];
    if (update.docs.isNotEmpty) {
      for (var doc in update.docs) {
        Relation rel = j.juicer.decode(doc.data(), (_) => Relation());
        _relations.add(rel);
        print("Relation: $rel, doc.reference.path: ${doc.reference.path}");
        DocumentSnapshot containerSnapshot = await fs.collection('containers').doc(rel.containerId.id).get();
        if (containerSnapshot != null) {
          _containers.add(j.juicer
              .decode(containerSnapshot.data(), (_) => ListContainer()..reference = containerSnapshot.reference));
        }
      }
    }
    relations = _relations;
    containers = _containers;
  }

  @action
  Future<void> add(DocumentReference userReference, ListContainer container) async {
    container.timeCreated = DateTime.now().millisecondsSinceEpoch;
    DocumentReference containerRef = await fs.collection("containers").add(j.juicer.encode(container));
    Relation relation = Relation()
      ..containerId = containerRef
      ..relation = "owner"
      ..userId = userReference;
    await fs.collection("relations").add(j.juicer.encode(relation));
  }

  @action
  Future<void> delete(ListContainer container) async {
    List<Future> deleteOperations = [];
    QuerySnapshot relations =
        await fs.collection("relations").where('containerId', isEqualTo: container.reference).get();
    for (var d in relations.docs) {
      deleteOperations.add(d.reference.delete());
    }
    await Future.wait(deleteOperations);
    //TODO: delete items collection
    await container.reference.delete();
  }

  void cleanUp() {
    relationChangeListener?.cancel();
  }
}
