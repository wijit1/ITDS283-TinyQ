// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAjqBX_z4O-xyNpRnPyuuigQBDBY21PFHg',
    appId: '1:356556379247:web:51b45a5c0628435499699a',
    messagingSenderId: '356556379247',
    projectId: 'tinyq-fbf70',
    authDomain: 'tinyq-fbf70.firebaseapp.com',
    storageBucket: 'tinyq-fbf70.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC46opviW3lFEYAanHyuDfZfNkFI9M03c4',
    appId: '1:356556379247:android:dafb0c26c4cc360199699a',
    messagingSenderId: '356556379247',
    projectId: 'tinyq-fbf70',
    storageBucket: 'tinyq-fbf70.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBL3HF7v8iLqbg_-MNbOE8ed0Ndnh27ipk',
    appId: '1:356556379247:ios:62d12141de9faca199699a',
    messagingSenderId: '356556379247',
    projectId: 'tinyq-fbf70',
    storageBucket: 'tinyq-fbf70.firebasestorage.app',
    iosBundleId: 'com.example.tinyq',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBL3HF7v8iLqbg_-MNbOE8ed0Ndnh27ipk',
    appId: '1:356556379247:ios:62d12141de9faca199699a',
    messagingSenderId: '356556379247',
    projectId: 'tinyq-fbf70',
    storageBucket: 'tinyq-fbf70.firebasestorage.app',
    iosBundleId: 'com.example.tinyq',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjqBX_z4O-xyNpRnPyuuigQBDBY21PFHg',
    appId: '1:356556379247:web:df3dc667fc670a4899699a',
    messagingSenderId: '356556379247',
    projectId: 'tinyq-fbf70',
    authDomain: 'tinyq-fbf70.firebaseapp.com',
    storageBucket: 'tinyq-fbf70.firebasestorage.app',
  );
}
