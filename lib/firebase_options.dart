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
    apiKey: 'AIzaSyBQJfk03ru2q_cDbZjUQLHH7Prhk12WFkY',
    appId: '1:337554272426:android:c1d567a085674fe96520d3',
    messagingSenderId: '337554272426',
    projectId: 'mwaslat-masr',
    databaseURL: 'https://mwaslat-masr-default-rtdb.firebaseio.com',
    storageBucket: 'mwaslat-masr.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxBh68K5AY2a7HQQHYvmXObrMw21CUQmQ',
    appId: '1:337554272426:ios:2da34ae39d104b996520d3',
    messagingSenderId: '337554272426',
    projectId: 'mwaslat-masr',
    databaseURL: 'https://mwaslat-masr-default-rtdb.firebaseio.com',
    storageBucket: 'mwaslat-masr.appspot.com',
    iosClientId: '337554272426-1ea7raujbp5fngb3as3vn8hs2lbmh46f.apps.googleusercontent.com',
    iosBundleId: 'com.elemamdev.mwaslat.masr.driver',
  );
}
