import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  User? googleUser;
  String? name, imageUrl, userEmail, uid;

  // final GoogleSignInPlugin googleSignIn = GoogleSignInPlugin();

  // String _token = '';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Future<void> _authenticate({
  //   required String email,
  //   required String password,
  //   required String urlSegment,
  // }) async {
  //   var acs = ActionCodeSettings(url: 'https://mouseirl.firebaseapp.com');
  //   FirebaseAuth.instance
  //       .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
  //       .catchError(
  //           (onError) => print('Error sending email verification $onError'))
  //       .then((value) => print('Successfully sent email verification'));
  //   //TODO: change to logger maybe idk how this works
  // }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    try {
      //web
      if (kIsWeb) {
        await _auth.signInWithRedirect(googleProvider);
      } else if (Platform.isAndroid || Platform.isIOS) {
        // TODO: implement
        // await _auth.signInWithProvider(googleProvider);
      }
    } catch (e) {
      // print(e);
    }

    if (googleUser != null) {
      name = googleUser!.displayName;
      imageUrl = googleUser!.photoURL;
      userEmail = googleUser!.email;
      uid = googleUser!.uid;

      // print("name: $name");
      // print("userEmail: $userEmail");
      // print("imageUrl: $imageUrl");
    }
  }

  Future<void> signOut() async {
    if (isLoggedIn()) {
      await _auth.signOut();
    }
  }

  bool isLoggedIn() {
    return currentUser != null;
  }

  Future<bool> isEmailVerified() async {
    if (currentUser == null) {
      return false;
    }
    return currentUser!.emailVerified;
  }

  // Future<void> sendEmailVerification() async {
  //   if (currentUser == null) {
  //     return;
  //   }
  // }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> getUserProfile() async {
    if (currentUser == null) {
      return;
    }
    name = currentUser!.displayName;
    imageUrl = currentUser!.photoURL;
    userEmail = currentUser!.email;
    uid = currentUser!.uid;
  }

  Future<void> updateUserName(String? name) async {
    if (currentUser == null) {
      return;
    }
    if (name != null && name != '') {
      currentUser!.updateDisplayName(name);
    }
  }

  Future<void> updateUserProfilePic(String? imageUrl) async {
    if (currentUser == null) {
      return;
    }
    if (imageUrl != null && imageUrl != '') {
      currentUser!.updatePhotoURL(imageUrl);
    }
  }
}
