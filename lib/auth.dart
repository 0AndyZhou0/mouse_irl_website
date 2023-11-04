import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  String _token = '';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    var acs = ActionCodeSettings(url: 'https://mouseirl.firebaseapp.com');
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
    //TODO: change to logger
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    return currentUser != null;
  }

  Future<bool> isEmailVerified() async {
    if (currentUser == null) {
      return false;
    }
    return currentUser!.emailVerified;
  }
}
