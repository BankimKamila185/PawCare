import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../models/user.dart';

class LocalStorageService {
  static const String _keyUsers = 'pawcare_users_list';
  static const String _keyCurrentUser = 'pawcare_current_user';
  static const String _keyPets = 'pawcare_pets_list';
  static const String _keyRemindersEnabled = 'pawcare_reminders_enabled';
  static const String _keyDismissedReminders = 'pawcare_dismissed_reminders';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ==================== USER STORAGE ====================

  Future<void> saveUser(User user) async {
    final users = getUsers();
    users.removeWhere((u) => u.email.toLowerCase() == user.email.toLowerCase());
    users.add(user);

    final jsonList = users.map((u) => u.toJson()).toList();
    await _prefs.setString(_keyUsers, jsonEncode(jsonList));
  }

  List<User> getUsers() {
    final raw = _prefs.getString(_keyUsers);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  User? getUser(String email) {
    final users = getUsers();
    try {
      return users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> setCurrentUser(User? user) async {
    if (user == null) {
      await _prefs.remove(_keyCurrentUser);
    } else {
      await _prefs.setString(_keyCurrentUser, jsonEncode(user.toJson()));
    }
  }

  User? getCurrentUser() {
    final raw = _prefs.getString(_keyCurrentUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // ==================== PETS STORAGE ====================

  Future<void> savePets(List<Pet> pets) async {
    final jsonList = pets.map((p) => p.toJson()).toList();
    await _prefs.setString(_keyPets, jsonEncode(jsonList));
  }

  List<Pet>? loadPets() {
    final raw = _prefs.getString(_keyPets);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => Pet.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ==================== PREFERENCES ====================

  bool getRemindersEnabled() {
    return _prefs.getBool(_keyRemindersEnabled) ?? true;
  }

  Future<void> setRemindersEnabled(bool value) async {
    await _prefs.setBool(_keyRemindersEnabled, value);
  }

  List<String> getDismissedReminders() {
    return _prefs.getStringList(_keyDismissedReminders) ?? [];
  }

  Future<void> dismissReminder(String reminderId) async {
    final list = getDismissedReminders();
    if (!list.contains(reminderId)) {
      list.add(reminderId);
      await _prefs.setStringList(_keyDismissedReminders, list);
    }
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
