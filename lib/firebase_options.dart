// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDVyY4Wb1oe84bqJaxEGJ6lFrcI4Imy4Fs',
    appId: '1:889428493541:web:dbb913e169d2ef5440800c',
    messagingSenderId: '889428493541',
    projectId: 'mouseirl',
    authDomain: 'mouseirl.firebaseapp.com',
    storageBucket: 'mouseirl.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsQif9VHw9DMatUm_LsUfkm7WriACskag',
    appId: '1:889428493541:android:6fd56f271cc884e940800c',
    messagingSenderId: '889428493541',
    projectId: 'mouseirl',
    storageBucket: 'mouseirl.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXDU1tE_uuH0WhMLak063UCKszaSywz3g',
    appId: '1:889428493541:ios:2f24c7609b54df1940800c',
    messagingSenderId: '889428493541',
    projectId: 'mouseirl',
    storageBucket: 'mouseirl.appspot.com',
    iosClientId: '889428493541-ksdkan3n0ovc1oh5petati71q8u9pmtk.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXDU1tE_uuH0WhMLak063UCKszaSywz3g',
    appId: '1:889428493541:ios:06aaf1a38e85088340800c',
    messagingSenderId: '889428493541',
    projectId: 'mouseirl',
    storageBucket: 'mouseirl.appspot.com',
    iosClientId: '889428493541-inuj4gigum39n8ro8nf8iv7oa3mq3jgm.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp.RunnerTests',
  );
}
