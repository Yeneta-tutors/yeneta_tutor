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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyASVwCdgYMYkOAKgti2mAti-frjjiS5ZiE',
    appId: '1:962677109525:web:8426eede421983437daf1c',
    messagingSenderId: '962677109525',
    projectId: 'yeneta-tutor',
    authDomain: 'yeneta-tutor.firebaseapp.com',
    storageBucket: 'yeneta-tutor.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRDzkSt0bkQbS3VyulA4PCMTl2epbV1dM',
    appId: '1:962677109525:android:33dbffa6b8af0ed37daf1c',
    messagingSenderId: '962677109525',
    projectId: 'yeneta-tutor',
    storageBucket: 'yeneta-tutor.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADs1ikbKrx494WyLNqdlm7zRcsYyDppyY',
    appId: '1:962677109525:ios:c986a809387bec6b7daf1c',
    messagingSenderId: '962677109525',
    projectId: 'yeneta-tutor',
    storageBucket: 'yeneta-tutor.appspot.com',
    iosBundleId: 'com.example.yenetaTutor',
  );
}
