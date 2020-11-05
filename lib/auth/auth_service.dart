import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobx/mobx.dart';
import 'package:pedantic/pedantic.dart';

import '../juiced/juiced.dart' as we;
import '../juiced/juiced.juicer.dart' as j;

part 'auth_service.g.dart';

class AuthService = _AuthService with _$AuthService;

abstract class _AuthService with Store {
  FirebaseAuth _fbAuth;
  FirebaseFirestore _fs;

  @observable
  bool initialized = false;

  @observable
  we.User user;

  @observable
  we.PublicProfile publicProfile;

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
      publicProfile = null;
      return;
    }
    if (!_fbAuth.currentUser.emailVerified) {
      // Unverified user, needs verification
      status = UserStatus.verificationRequired;
      if (verificationStatusTimer == null) {
        unawaited(sendVerificationEmailIfPermitted());
        verificationStatusTimer = Timer.periodic(verificationStatusPollPeriod, (timer) {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (now - (lastVerificationEmailSent ?? 0) > verificationEmailDelay) {
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

  /// Fetches or creates user and publicProfile documents for currently logged in Firebase user
  Future<void> fetchUserAccount() async {
    we.User currentUser;
    we.PublicProfile currentPublicProfile;

    DocumentSnapshot userSnapshot = await _fs.collection(we.User.collectionName).doc(_fbAuth.currentUser.uid).get();
    if (!userSnapshot.exists) {
      DocumentReference userRef = _fs.collection(we.User.collectionName).doc(_fbAuth.currentUser.uid);
      String displayName = _fbAuth.currentUser.displayName ?? _fbAuth.currentUser.email.split("@").first;
      final newUser = we.User()
        ..email = _fbAuth.currentUser.email
        ..displayName = displayName
        ..reference = userRef;
      final encodedUser = j.juicer.encode(newUser);
      await userRef.set(encodedUser);
      currentUser = newUser;
    } else {
      currentUser = j.juicer.decode(userSnapshot.data(), (_) => we.User()..reference = userSnapshot.reference);
    }

    DocumentSnapshot publicProfileSnapshot =
        await _fs.collection(we.PublicProfile.collectionName).doc(_fbAuth.currentUser.uid).get();
    if (!publicProfileSnapshot.exists) {
      DocumentReference publicProfileRef = _fs.collection(we.PublicProfile.collectionName).doc(_fbAuth.currentUser.uid);
      String displayName = _fbAuth.currentUser.displayName ?? _fbAuth.currentUser.email.split("@").first;
      final newPublicProfile = we.PublicProfile()
        ..email = _fbAuth.currentUser.email
        ..displayName = displayName
        ..reference = publicProfileRef;
      final encodedPublicProfile = j.juicer.encode(newPublicProfile);
      await publicProfileRef.set(encodedPublicProfile);
      currentPublicProfile = newPublicProfile;
    } else {
      currentPublicProfile = j.juicer
          .decode(publicProfileSnapshot.data(), (_) => we.PublicProfile()..reference = publicProfileSnapshot.reference);
    }
    // Update observable user and publicProfile in a sync atomic operation
    user = currentUser;
    publicProfile = currentPublicProfile;
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
    if (now - (lastVerificationEmailSent ?? 0) > verificationEmailDelay) {
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

  static final verificationEmailDelay = Duration(seconds: 10).inMilliseconds;
  static final verificationStatusPollPeriod = Duration(seconds: 3);
}

enum UserStatus { loggedOut, verificationRequired, loggedIn }
