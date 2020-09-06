import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobx/mobx.dart';

import '../juiced/juiced.dart' as we;
import '../juiced/juiced.juicer.dart' as j;

part 'auth.g.dart';

class Auth = _Auth with _$Auth;

abstract class _Auth with Store {
  FirebaseAuth _fbAuth;
  FirebaseFirestore _fs;

  @observable
  DocumentReference userReference;

  @observable
  we.User user;

  @computed
  bool get isAuthed => user != null && userReference != null;

  @observable
  bool initialized = false;

  @observable
  bool animationInProgress = false;

  @computed
  we.User get uiUser => animationInProgress ? null : user;

  _Auth() {
    print("Auth: $hashCode");
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await Future.delayed(Duration(seconds: 2));
    _fbAuth = FirebaseAuth.instance;
    _fs = FirebaseFirestore.instance;
    _fbAuth.authStateChanges().listen(_userUpdate);
  }

  Future<void> _userUpdate(User update) async {
    if (update == null) {
      print("Auth userUpdate: logged out");
    } else {
      print("Auth userUpdate: ${update.email} logged in");
    }
    await _getUserDocument();
    initialized = true;
  }

  Future<void> _getUserDocument() async {
    if (_fbAuth.currentUser == null) {
      // Visitor is logged out
      clear();
      return;
    }
    QuerySnapshot snapshot = await _fs.collection("users").where("authId", isEqualTo: _fbAuth.currentUser.uid).get();
    if (snapshot.docs.isEmpty) {
      // No user with such external id
      clear();
      throw StateError("User is present in FB Auth but not in users collection");
    } else {
      QueryDocumentSnapshot qs = snapshot.docs.first;
      userReference = qs.reference;
      user = j.juicer.decode(qs.data(), (_) => we.User());
    }
    print("User object after getUserDocument(): $user");
  }

  @action
  void startAnimation() {
    print("Auth: animation started");
    animationInProgress = true;
  }

  @action
  void completeAnimation() {
    print("Auth: animation stopped");
    animationInProgress = false;
  }

  void clear() {
    userReference = null;
    user = null;
  }
}
