import 'package:shared_preferences/shared_preferences.dart';

class SettingsServices {
  static const _keyNotifications = 'notifications_enabled';
  static const _keyLanguage = 'app_language';
  static const _keyProfileImage = 'profile_image_path';
  static const _keyUserName = 'user_name';
  static const _keyUserEmail = 'user_email';

  // ── Notifications ──────────────────────────────────
  static Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }

  static Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
  }

  // ── Language ───────────────────────────────────────
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'English';
  }

  static Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, value);
  }

  // ── Profile Image ──────────────────────────────────
  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImage);
  }

  static Future<void> setProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImage, path);
  }

  // ── User Info ──────────────────────────────────────
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Traveller';
  }

  static Future<void> setUserName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, value);
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? '';
  }

  static Future<void> setUserEmail(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, value);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileImage);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }
}