// File generated for PawCare Flutter Firebase configuration
// Based on Firebase Project: petcare-75450
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
  static dynamic get currentPlatform {
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

  static const web = {
    'apiKey': 'AIzaSyC-m5E5D-uQt2Vpm9D-3latSsVow6AlGtI',
    'appId': '1:135703789548:web:94ce35dac75edc5df4cac9',
    'messagingSenderId': '135703789548',
    'projectId': 'petcare-75450',
    'authDomain': 'petcare-75450.firebaseapp.com',
    'storageBucket': 'petcare-75450.firebasestorage.app',
    'measurementId': 'G-KQCP05F1EQ',
  };

  static const android = {
    'apiKey': 'AIzaSyC-m5E5D-uQt2Vpm9D-3latSsVow6AlGtI',
    'appId': '1:135703789548:android:56e0edf315',
    'messagingSenderId': '135703789548',
    'projectId': 'petcare-75450',
    'storageBucket': 'petcare-75450.firebasestorage.app',
  };

  static const ios = {
    'apiKey': 'AIzaSyC-m5E5D-uQt2Vpm9D-3latSsVow6AlGtI',
    'appId': '1:135703789548:ios:56e0edf315',
    'messagingSenderId': '135703789548',
    'projectId': 'petcare-75450',
    'storageBucket': 'petcare-75450.firebasestorage.app',
    'iosBundleId': 'com.pawcare.app',
  };

  static const macos = ios;
  static const windows = web;
}
