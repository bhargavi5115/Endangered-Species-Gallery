import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  /// Initializes Firebase safely with fallback for unconfigured environments
  static Future<void> initialize() async {
    try {
      // In web or configured platforms, initialize Firebase
      await Firebase.initializeApp();
      _isInitialized = true;
      developer.log('Firebase initialized successfully', name: 'FirebaseService');
    } catch (e) {
      _isInitialized = false;
      developer.log(
        'Firebase not configured or initialized for this platform ($e). Running in resilient offline / local guest mode.',
        name: 'FirebaseService',
      );
    }
  }
}
