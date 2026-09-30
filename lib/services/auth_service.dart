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
    _currentUser = _storage.getCurrentUser();
    // If no user exists at all, seed a default demo user for convenience
    if (_storage.getUsers().isEmpty) {
      const demoUser = User(
        id: 'user_demo_01',
        name: 'Alex Davis',
        email: 'alex.davis@pawcare.org',
        password: 'password123',
        location: 'Austin, TX',
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

    final newUser = User(
      id: const Uuid().v4(),
      name: trimmedName,
      email: trimmedEmail,
      password: password,
      location: 'Austin, TX',
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
