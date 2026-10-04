import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'local_storage_service.dart';

class AuthService extends ChangeNotifier {
  final LocalStorageService _storage;
  User? _currentUser;

  AuthService(this._storage) {
    _initUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void _initUser() {
    try {
      if (Firebase.apps.isNotEmpty) {
        final fbUser = fb.FirebaseAuth.instance.currentUser;
        if (fbUser != null) {
          _currentUser = User(
            id: fbUser.uid,
            name: fbUser.displayName ?? fbUser.email?.split('@').first ?? 'User',
            email: fbUser.email ?? '',
            password: '',
            location: 'Bengaluru, Karnataka',
          );
          notifyListeners();
          return;
        }
      }
    } catch (_) {}

    _currentUser = _storage.getCurrentUser();
    // If no user exists at all, seed a default demo user for convenience
    if (_storage.getUsers().isEmpty) {
      const demoUser = User(
        id: 'user_demo_01',
        name: 'Aarav Sharma',
        email: 'aarav.sharma@pawcare.in',
        password: 'password123',
        location: 'Bengaluru, Karnataka',
      );
      _storage.saveUser(demoUser);
    }
    notifyListeners();
  }

  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedName.isEmpty) {
      return AuthResult.failure('Please enter your full name.');
    }
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      return AuthResult.failure('Please enter a valid email address.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }
    if (password != confirmPassword) {
      return AuthResult.failure('Passwords do not match.');
    }

    final existingUser = _storage.getUser(trimmedEmail);
    if (existingUser != null) {
      return AuthResult.failure('An account with this email already exists.');
    }

    String userId = const Uuid().v4();

    // 1. Attempt Firebase Authentication
    try {
      if (Firebase.apps.isNotEmpty) {
        final userCredential = await fb.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        if (userCredential.user != null) {
          userId = userCredential.user!.uid;
          await userCredential.user!.updateDisplayName(trimmedName);
        }
      }
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AuthResult.failure('An account with this email already exists.');
      } else if (e.code == 'weak-password') {
        return AuthResult.failure('The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        return AuthResult.failure('Please enter a valid email address.');
      } else if (e.code == 'operation-not-allowed') {
        return AuthResult.failure(
          'Email/Password sign-in is not enabled in Firebase Console. Please enable it under Firebase Auth > Sign-in method.',
        );
      }
      return AuthResult.failure(e.message ?? 'Registration failed in Firebase.');
    } catch (e) {
      debugPrint('Firebase signUp notice: $e');
    }

    final newUser = User(
      id: userId,
      name: trimmedName,
      email: trimmedEmail,
      password: password,
      location: 'Bengaluru, Karnataka',
    );

    await _storage.saveUser(newUser);
    _currentUser = newUser;
    await _storage.setCurrentUser(newUser);
    notifyListeners();

    return AuthResult.success(newUser);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return AuthResult.failure('Please enter your email.');
    }
    if (password.isEmpty) {
      return AuthResult.failure('Please enter your password.');
    }

    // 1. Attempt Firebase Authentication
    try {
      if (Firebase.apps.isNotEmpty) {
        final userCredential = await fb.FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        if (userCredential.user != null) {
          final fbU = userCredential.user!;
          final loggedInUser = User(
            id: fbU.uid,
            name: fbU.displayName ?? trimmedEmail.split('@').first,
            email: fbU.email ?? trimmedEmail,
            password: password,
            location: 'Bengaluru, Karnataka',
          );

          await _storage.saveUser(loggedInUser);
          _currentUser = loggedInUser;
          await _storage.setCurrentUser(loggedInUser);
          notifyListeners();

          return AuthResult.success(loggedInUser);
        }
      }
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return AuthResult.failure('Incorrect email or password.');
      }
      return AuthResult.failure(e.message ?? 'Login failed in Firebase.');
    } catch (e) {
      debugPrint('Firebase login notice: $e');
    }

    // 2. Fallback to Local Storage (e.g. for demo users or offline test mode)
    final user = _storage.getUser(trimmedEmail);
    if (user == null) {
      return AuthResult.failure('Account not found. Please sign up first.');
    }
    if (user.password != password) {
      return AuthResult.failure('Incorrect password. Please try again.');
    }

    _currentUser = user;
    await _storage.setCurrentUser(user);
    notifyListeners();

    return AuthResult.success(user);
  }

  Future<void> logout() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        await fb.FirebaseAuth.instance.signOut();
      }
    } catch (_) {}

    _currentUser = null;
    await _storage.setCurrentUser(null);
    notifyListeners();
  }
}

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;

  const AuthResult._({required this.isSuccess, this.errorMessage, this.user});

  factory AuthResult.success(User user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}
