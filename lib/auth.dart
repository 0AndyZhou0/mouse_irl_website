import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  User? googleUser;
  String? name, imageUrl, userEmail, uid;

  final Logger _logger = Logger('Auth');

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
    _logger.fine('Attempting to create a user with email and password');

    if (isLoggedIn()) {
      _logger.fine('Already logged in');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _logger.fine('User creation with email and password succeeded');
    } on FirebaseAuthException catch (e) {
      _logger.severe('Failed to create a user with email and password', e);
      throw FirebaseAuthException(
        code: e.code,
        message: 'Failed to create a user with email and password',
      );
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _logger.fine('Attempting to sign in with email and password');

    if (isLoggedIn()) {
      _logger.fine('Already logged in');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _logger.fine('Sign in with email and password succeeded');
    } on FirebaseAuthException catch (e) {
      _logger.warning('Failed to sign in with email and password', e);
      throw FirebaseAuthException(
        code: e.code,
        message: 'Failed to sign in with email and password',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    _logger.fine('Signing in with Google');

    if (isLoggedIn()) {
      _logger.fine('Already logged in');
      return;
    }

    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    try {
      //web
      if (kIsWeb) {
        _logger.finer('Signing in with Google on web');
        await _auth.signInWithRedirect(googleProvider);
      } else if (Platform.isAndroid || Platform.isIOS) {
        _logger.finer('Signing in with Google on mobile');
        // TODO: implement
        await _auth.signInWithProvider(googleProvider);
      }
    } catch (e) {
      _logger.warning('Error signing in with Google: $e');
    }

    // _logger.finest('Google user: $googleUser');

    if (googleUser != null) {
      _logger.fine('Signing in with Google succeeded');
      name = googleUser!.displayName;
      imageUrl = googleUser!.photoURL;
      userEmail = googleUser!.email;
      uid = googleUser!.uid;

      _logger.finest('name: $name');
      _logger.finest('userEmail: $userEmail');
      _logger.finest('imageUrl: $imageUrl');
    }
  }

  Future<void> signOut() async {
    _logger.fine('Attempting to sign out');

    if (isLoggedIn()) {
      await _auth.signOut();
      _logger.fine('Sign out successful');
    } else {
      _logger.fine('User is not logged in, sign out aborted');
    }
  }

  bool isLoggedIn() {
    return currentUser != null;
  }

  Future<bool> isEmailVerified() async {
    if (!isLoggedIn()) {
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
    _logger.fine('Attempting to send password reset email to $email');
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _logger.fine('Password reset email sent successfully to $email');
    } catch (e) {
      _logger.severe('Failed to send password reset email to $email', e);
      rethrow;
    }
  }

  Future<void> getUserProfile() async {
    if (!isLoggedIn()) {
      _logger.finest('User not logged in, aborting...');
      return;
    }
    name = currentUser!.displayName;
    _logger.finest('Name retrieved: $name');
    imageUrl = currentUser!.photoURL;
    _logger.finest('Image URL retrieved: $imageUrl');
    userEmail = currentUser!.email;
    _logger.finest('Email retrieved: $userEmail');
    uid = currentUser!.uid;
    _logger.finest('UID retrieved: $uid');
  }

  Future<void> updateUserName(String? name) async {
    _logger.finest('Attempting to update user name');
    if (!isLoggedIn()) {
      _logger.finest('User not logged in, aborting...');
      return;
    }
    _logger.fine('Updating user name to $name');
    if (name != null && name != '') {
      try {
        await currentUser!.updateDisplayName(name);
        _logger.fine('User name updated to $name');
      } catch (e) {
        _logger.warning('Failed to update user name to $name', e);
      }
    }
  }

  Future<void> updateUserProfilePic(String? imageUrl) async {
    _logger.finest('Attempting to update user profile picture');
    if (!isLoggedIn()) {
      _logger.finest('User not logged in, aborting...');
      return;
    }
    _logger.fine('Updating user profile picture to $imageUrl');
    if (imageUrl != null && imageUrl != '') {
      try {
        await currentUser!.updatePhotoURL(imageUrl);
        _logger.fine('User profile picture updated to $imageUrl');
      } catch (e) {
        _logger.severe('Failed to update user profile picture to $imageUrl', e);
      }
    } else {
      _logger.finer('No image URL provided, skipping profile picture update');
    }
  }
}
