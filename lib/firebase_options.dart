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
    apiKey: 'AIzaSyA0hyOrVm3KVhte_gRFJo5NRfywKQLKRBo',
    appId: '1:884303056898:web:fed570dbecac7c68ed971b',
    messagingSenderId: '884303056898',
    projectId: 'filesapp-dea64',
    authDomain: 'filesapp-dea64.firebaseapp.com',
    storageBucket: 'filesapp-dea64.appspot.com',
    measurementId: 'G-BHJLHJHSXR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAcMpBJuQ5Z0a8pqwOU0kt_66Y-T_eMz0',
    appId: '1:884303056898:android:2806f46a5668245ced971b',
    messagingSenderId: '884303056898',
    projectId: 'filesapp-dea64',
    storageBucket: 'filesapp-dea64.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLfBGQ_QJgsTheKco2y8d0q_3xxpwmchI',
    appId: '1:884303056898:ios:448c3f77498dc328ed971b',
    messagingSenderId: '884303056898',
    projectId: 'filesapp-dea64',
    storageBucket: 'filesapp-dea64.appspot.com',
    iosClientId: '884303056898-rv3a9tk64ns5chdhg669h3j0lu4m9if0.apps.googleusercontent.com',
    iosBundleId: 'com.example.filesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBLfBGQ_QJgsTheKco2y8d0q_3xxpwmchI',
    appId: '1:884303056898:ios:ead8089754d0f328ed971b',
    messagingSenderId: '884303056898',
    projectId: 'filesapp-dea64',
    storageBucket: 'filesapp-dea64.appspot.com',
    iosClientId: '884303056898-8bc71r687aqbo9i90u59tp6dgrl5fvfm.apps.googleusercontent.com',
    iosBundleId: 'com.example.filesApp.RunnerTests',
  );
}
