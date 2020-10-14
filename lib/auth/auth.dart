import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';

import '../juiced/juiced.dart' as we;
import '../juiced/juiced.juicer.dart' as j;

part 'auth.g.dart';

class Auth = _Auth with _$Auth;

abstract class _Auth with Store {
  FirebaseAuth _fbAuth;
  FirebaseFirestore _fs;

  @observable
  bool initialized = false;

  @observable
  we.User user;

  @observable
  UserStatus status;

  Timer verificationStatusTimer;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    _fbAuth = FirebaseAuth.instance;
    _fs = FirebaseFirestore.instance;
    _fbAuth.userChanges().distinct((a, b) => a?.uid == b?.uid).listen(_userUpdate);
  }

  Future<void> _userUpdate(User update) async {
    if (update == null) {
      print("Auth userUpdate: logged out");
    } else {
      print("Auth userUpdate: ${update.email} logged in, verified: ${update.emailVerified}");
    }
    await _handleUserUpdate();
    initialized = true;
  }

  Future<void> _handleUserUpdate() async {
    if (_fbAuth.currentUser == null) {
      // Visitor is logged out
      status = UserStatus.loggedOut;
      user = null;
      return;
    }
    if (!_fbAuth.currentUser.emailVerified) {
      // Unverified user, needs verification
      status = UserStatus.verificationRequired;
      if (verificationStatusTimer == null) {
        unawaited(_fbAuth.currentUser.sendEmailVerification());
        verificationStatusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
          _fbAuth.currentUser.reload();
          print("verificationStatusTimer: ${_fbAuth.currentUser.emailVerified}");
          if (_fbAuth.currentUser.emailVerified) {
            timer.cancel();
            timer = null;
            fetchUserAccount();
          }
        });
      }
      return;
    }
    await fetchUserAccount();
  }

  Future<void> fetchUserAccount() async {
    QuerySnapshot userSnapshot = await _fs.collection("users").where("authId", isEqualTo: _fbAuth.currentUser.uid).get();
    if (userSnapshot.docs.isEmpty) {
      String displayName = _fbAuth.currentUser.displayName ?? _fbAuth.currentUser.email.split("@").first;
      final newUser = we.User()
        ..authId = _fbAuth.currentUser.uid
        ..email = _fbAuth.currentUser.email
        ..displayName = displayName;
      DocumentReference userRef = await _fs.collection("users").add(j.juicer.encode(newUser));
      newUser.reference = userRef;
      user = newUser;
      print("fetchUserAccount: user created: $user");
    } else {
      QueryDocumentSnapshot currentUserSnapshot = userSnapshot.docs.first;
      user = j.juicer.decode(currentUserSnapshot.data(), (_) => we.User()..reference = currentUserSnapshot.reference);
      print("fetchUserAccount: user fetched: $user");
    }
    status = UserStatus.loggedIn;
  }
}

enum UserStatus { loggedOut, verificationRequired, loggedIn }
