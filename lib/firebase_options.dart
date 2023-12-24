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
    apiKey: 'AIzaSyCptMjmAXnmTCoOiS0FoDSziSBBo5q2HAc',
    appId: '1:419346324392:web:de7f91cf886873943fdb9d',
    messagingSenderId: '419346324392',
    projectId: 'atelier4-p-ouatil-iir5g7',
    authDomain: 'atelier4-p-ouatil-iir5g7.firebaseapp.com',
    storageBucket: 'atelier4-p-ouatil-iir5g7.appspot.com',
    measurementId: 'G-G6GF3D6XP0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQ8TVPooewTVBLlXc5KT9luG8Fo4bBSkU',
    appId: '1:419346324392:android:6ff900980ea6a92a3fdb9d',
    messagingSenderId: '419346324392',
    projectId: 'atelier4-p-ouatil-iir5g7',
    storageBucket: 'atelier4-p-ouatil-iir5g7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7OMi-68-Jx-MQoLx8eKqlZHtI2uvhKS8',
    appId: '1:419346324392:ios:f53a7a49c41399543fdb9d',
    messagingSenderId: '419346324392',
    projectId: 'atelier4-p-ouatil-iir5g7',
    storageBucket: 'atelier4-p-ouatil-iir5g7.appspot.com',
    iosBundleId: 'com.example.atelier4AnasOuatilIir5g7',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7OMi-68-Jx-MQoLx8eKqlZHtI2uvhKS8',
    appId: '1:419346324392:ios:45ecb4ea806df96b3fdb9d',
    messagingSenderId: '419346324392',
    projectId: 'atelier4-p-ouatil-iir5g7',
    storageBucket: 'atelier4-p-ouatil-iir5g7.appspot.com',
    iosBundleId: 'com.example.atelier4AnasOuatilIir5g7.RunnerTests',
  );
}
