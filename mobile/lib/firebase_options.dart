import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnQx7tWkmQSNQgcWAtl0gdYP6Po7nT3DM',
    appId: '1:917797506730:android:6b8861bebe54c08b254ad3',
    messagingSenderId: '917797506730',
    projectId: 'tweetbooster-8bede',
    storageBucket: 'tweetbooster-8bede.firebasestorage.app',
  );

  // iOS - Firebase Console'dan iOS app eklendiğinde güncellenecek
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAnQx7tWkmQSNQgcWAtl0gdYP6Po7nT3DM',
    appId: '1:917797506730:android:6b8861bebe54c08b254ad3', // iOS app id ile değiştirilecek
    messagingSenderId: '917797506730',
    projectId: 'tweetbooster-8bede',
    storageBucket: 'tweetbooster-8bede.firebasestorage.app',
    iosBundleId: 'com.rkt.tweetboost',
  );

  // Web - Firebase Console'dan Web app eklendiğinde güncellenecek
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAnQx7tWkmQSNQgcWAtl0gdYP6Po7nT3DM',
    appId: '1:917797506730:android:6b8861bebe54c08b254ad3', // Web app id ile değiştirilecek
    messagingSenderId: '917797506730',
    projectId: 'tweetbooster-8bede',
    storageBucket: 'tweetbooster-8bede.firebasestorage.app',
    authDomain: 'tweetbooster-8bede.firebaseapp.com',
  );

  // macOS - iOS ile aynı ayarlar
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAnQx7tWkmQSNQgcWAtl0gdYP6Po7nT3DM',
    appId: '1:917797506730:android:6b8861bebe54c08b254ad3',
    messagingSenderId: '917797506730',
    projectId: 'tweetbooster-8bede',
    storageBucket: 'tweetbooster-8bede.firebasestorage.app',
    iosBundleId: 'com.rkt.tweetboost',
  );

  // Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnQx7tWkmQSNQgcWAtl0gdYP6Po7nT3DM',
    appId: '1:917797506730:android:6b8861bebe54c08b254ad3',
    messagingSenderId: '917797506730',
    projectId: 'tweetbooster-8bede',
    storageBucket: 'tweetbooster-8bede.firebasestorage.app',
    authDomain: 'tweetbooster-8bede.firebaseapp.com',
  );
}
