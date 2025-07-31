// File: lib/firebase_options.dart
// Dihasilkan dan diperbarui secara otomatis berdasarkan konfigurasi Firebase Anda.
// JANGAN UBAH FILE INI SECARA MANUAL.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // --- KONFIGURASI UNTUK WEB ---
      return const FirebaseOptions(
        apiKey: "AIzaSyAr4VxHcsI8Y9hbXiMJgwweKhBY74rx4Vk",
        appId: "1:799553087212:web:1f2804a712bcf64730a7c9",
        messagingSenderId: "799553087212",
        projectId: "penyewaanbaju",
        authDomain: "penyewaanbaju.firebaseapp.com",
        storageBucket: "penyewaanbaju.appspot.com", // Saya perbaiki domain storage bucket
        measurementId: "G-ZP8Y2JLFQX",
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      // --- KONFIGURASI UNTUK ANDROID ---
        return const FirebaseOptions(
          apiKey: "AIzaSyAr4VxHcsI8Y9hbXiMJgwweKhBY74rx4Vk",
          appId: "1:799553087212:android:YOUR_ANDROID_APP_ID", // Ganti dengan App ID Android dari konsol Firebase
          messagingSenderId: "799553087212",
          projectId: "penyewaanbaju",
          storageBucket: "penyewaanbaju.appspot.com",
        );
      case TargetPlatform.iOS:
      // --- KONFIGURASI UNTUK IOS ---
        return const FirebaseOptions(
          apiKey: "AIzaSyAr4VxHcsI8Y9hbXiMJgwweKhBY74rx4Vk",
          appId: "1:799553087212:ios:YOUR_IOS_APP_ID", // Ganti dengan App ID iOS dari konsol Firebase
          messagingSenderId: "799553087212",
          projectId: "penyewaanbaju",
          storageBucket: "penyewaanbaju.appspot.com",
          iosBundleId: 'com.example.penyewaanbaju', // Ganti dengan bundle ID iOS Anda
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}