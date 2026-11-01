import 'dart:async';
import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'local_storage_service.dart';

class AuthService {
  final LocalStorageService _storage;
  final StreamController<UserModel?> _userStreamController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  AuthService(this._storage) {
    _initAuthListener();
  }

  UserModel? get currentUser => _currentUser;
  Stream<UserModel?> get authStateChanges => _userStreamController.stream;

  void _initAuthListener() {
    if (FirebaseService.isInitialized) {
      try {
        fb_auth.FirebaseAuth.instance.authStateChanges().listen((fbUser) {
          if (fbUser != null) {
            _currentUser = UserModel(
              userId: fbUser.uid,
              displayName: fbUser.displayName ?? fbUser.email?.split('@').first ?? 'Wildlife Supporter',
              email: fbUser.email ?? '',
              profileImage: fbUser.photoURL,
              createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
              isGuest: false,
            );
            _storage.setGuestUser(false);
          } else {
            // Check if local guest session was active
            if (_storage.isGuestUser()) {
              _currentUser = UserModel.guest();
            } else {
              _currentUser = null;
            }
          }
          _userStreamController.add(_currentUser);
        });
        return;
      } catch (e) {
        developer.log('Error listening to FirebaseAuth: $e', name: 'AuthService');
      }
    }

    // Offline / Local mode initialization
    if (_storage.isGuestUser()) {
      _currentUser = UserModel.guest();
    }
    _userStreamController.add(_currentUser);
  }

  /// Sign In with Email & Password
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      throw Exception('Email and password must not be empty.');
    }

    if (FirebaseService.isInitialized) {
      try {
        final credential = await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final fbUser = credential.user!;
        final user = UserModel(
          userId: fbUser.uid,
          displayName: fbUser.displayName ?? trimmedEmail.split('@').first,
          email: trimmedEmail,
          profileImage: fbUser.photoURL,
          createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
          isGuest: false,
        );
        _currentUser = user;
        await _storage.setGuestUser(false);
        _userStreamController.add(_currentUser);
        return user;
      } on fb_auth.FirebaseAuthException catch (e) {
        throw Exception(e.message ?? 'Authentication failed.');
      }
    }

    // Local / Resilient authentication
    final user = UserModel(
      userId: 'usr_${trimmedEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
      displayName: trimmedEmail.split('@').first,
      email: trimmedEmail,
      createdAt: DateTime.now(),
      isGuest: false,
    );
    _currentUser = user;
    await _storage.setGuestUser(false);
    _userStreamController.add(_currentUser);
    return user;
  }

  /// Register with Email & Password
  Future<UserModel> registerWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedName = displayName.trim();

    if (trimmedEmail.isEmpty || password.length < 6) {
      throw Exception('Please provide a valid email and a password of at least 6 characters.');
    }

    if (FirebaseService.isInitialized) {
      try {
        final credential = await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final fbUser = credential.user!;
        await fbUser.updateDisplayName(trimmedName.isNotEmpty ? trimmedName : 'Wildlife Protector');

        final user = UserModel(
          userId: fbUser.uid,
          displayName: trimmedName.isNotEmpty ? trimmedName : 'Wildlife Protector',
          email: trimmedEmail,
          createdAt: DateTime.now(),
          isGuest: false,
        );
        _currentUser = user;
        await _storage.setGuestUser(false);
        _userStreamController.add(_currentUser);
        return user;
      } on fb_auth.FirebaseAuthException catch (e) {
        throw Exception(e.message ?? 'Registration failed.');
      }
    }

    // Local / Resilient registration
    final user = UserModel(
      userId: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      displayName: trimmedName.isNotEmpty ? trimmedName : 'Wildlife Protector',
      email: trimmedEmail,
      createdAt: DateTime.now(),
      isGuest: false,
    );
    _currentUser = user;
    await _storage.setGuestUser(false);
    _userStreamController.add(_currentUser);
    return user;
  }

  /// Guest Sign In
  Future<UserModel> signInAsGuest() async {
    final guest = UserModel.guest();
    _currentUser = guest;
    await _storage.setGuestUser(true);
    _userStreamController.add(_currentUser);
    return guest;
  }

  /// Password Reset
  Future<void> sendPasswordReset(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw Exception('Please enter an email address.');
    }

    if (FirebaseService.isInitialized) {
      try {
        await fb_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: trimmedEmail);
      } on fb_auth.FirebaseAuthException catch (e) {
        throw Exception(e.message ?? 'Password reset failed.');
      }
    }
    // In local mode, completes successfully
  }

  /// Sign Out
  Future<void> signOut() async {
    if (FirebaseService.isInitialized) {
      try {
        await fb_auth.FirebaseAuth.instance.signOut();
      } catch (e) {
        developer.log('Signout error: $e', name: 'AuthService');
      }
    }
    _currentUser = null;
    await _storage.setGuestUser(false);
    _userStreamController.add(null);
  }

  void dispose() {
    _userStreamController.close();
  }
}
