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
  bool resendVerificationEmailDisabled = false;

  @observable
  UserStatus status;

  Timer verificationStatusTimer;

  int lastVerificationEmailSent;

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
        unawaited(sendVerificationEmailIfPermitted());
        verificationStatusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (now - (lastVerificationEmailSent ?? 0) > verificationEmailPeriod) {
            resendVerificationEmailDisabled = false;
          }
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
    QuerySnapshot userSnapshot =
        await _fs.collection("users").where("authId", isEqualTo: _fbAuth.currentUser.uid).get();
    if (userSnapshot.docs.isEmpty) {
      String displayName = _fbAuth.currentUser.displayName ?? _fbAuth.currentUser.email.split("@").first;
      final newUser = we.User()
        ..authId = _fbAuth.currentUser.uid
        ..email = _fbAuth.currentUser.email
        ..displayName = displayName;
      DocumentReference userRef = await _fs.collection("users").add(j.juicer.encode(newUser));
      newUser.reference = userRef;
      user = newUser;
    } else {
      QueryDocumentSnapshot currentUserSnapshot = userSnapshot.docs.first;
      user = j.juicer.decode(currentUserSnapshot.data(), (_) => we.User()..reference = currentUserSnapshot.reference);
    }
    status = UserStatus.loggedIn;
  }

  Future<void> login(String email, String password) async {
    await _fbAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (verificationStatusTimer != null) {
      verificationStatusTimer.cancel();
      verificationStatusTimer = null;
    }
    await _fbAuth.signOut();
  }

  Future<void> register(String email, String password) async {
    await _fbAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    await _fbAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendVerificationEmailIfPermitted() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - (lastVerificationEmailSent ?? 0) > verificationEmailPeriod) {
      try {
        await _fbAuth.currentUser.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          print("Too many attempts at sending verification email to ${_fbAuth.currentUser.email}");
        } else {
          rethrow;
        }
      } finally {
        lastVerificationEmailSent = now;
        resendVerificationEmailDisabled = true;
      }
    }
  }

  static final verificationEmailPeriod = Duration(seconds: 10).inMilliseconds;
}

enum UserStatus { loggedOut, verificationRequired, loggedIn }
