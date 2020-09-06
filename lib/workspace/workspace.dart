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

  _Workspace(this.auth) : fs = FirebaseFirestore.instance;

  void initialize() {
    autorun((_) => load(auth.uiUser));
  }

  @action
  Future<void> load(dynamic _) async {
    print("************** Workspace.load() called via reaction on auth.user: ${auth.user}");
    if (auth.uiUser == null) {
      containers = null;
      relations = null;
      return;
    }

    QuerySnapshot snapshot = await fs
        .collection('relations')
        .where('userId', isEqualTo: auth.userReference)
        .where('relation', whereIn: ['owner', 'accessor']).get();
    List<Relation> _relations = [];
    List<ListContainer> _containers = [];
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        Relation rel = j.juicer.decode(doc.data(), (_) => Relation());
        _relations.add(rel);
        print("Relation: $rel, doc.reference.path: ${doc.reference.path}");
        DocumentSnapshot containerSnapshot =
            await fs.collection('containers').doc(rel.containerId.id).get();
        if (containerSnapshot != null) {
          _containers.add(j.juicer.decode(containerSnapshot.data(), (_) => ListContainer()));
        }
      }
    }
    relations = _relations;
    containers = _containers;
    print(containers);
  }

  @action
  Future<void> add(String userId, ListContainer container) async {
    // TODO: add container and relations
  }

  @action
  Future<void> delete(ListContainer container) async {
    //TODO: remove container, items collection and relations as well
  }
}
