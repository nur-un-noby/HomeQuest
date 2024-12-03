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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw1OHJwe_9iTDIa_4A1A7gPb5f2nZpHhY',
    appId: '1:708186605626:android:683b23c799ded4bc8c0d03',
    messagingSenderId: '708186605626',
    projectId: 'home-quest-a86d6',
    storageBucket: 'home-quest-a86d6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUGiV0l-7ssE82_laI39Jaf9ZZGZRmz5Y',
    appId: '1:708186605626:ios:6bcbb424e188565d8c0d03',
    messagingSenderId: '708186605626',
    projectId: 'home-quest-a86d6',
    storageBucket: 'home-quest-a86d6.firebasestorage.app',
    androidClientId: '708186605626-uig6mslj9eqcgg2icj76avaponkpjjj8.apps.googleusercontent.com',
    iosClientId: '708186605626-8l2aq3qmavnvoh34o822b01ufk0l9siq.apps.googleusercontent.com',
    iosBundleId: 'com.example.realstateclient',
  );
}
