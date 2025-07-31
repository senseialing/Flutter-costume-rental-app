// File: lib/utils/preferences_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _isLoggedInKey = 'isLoggedIn';

  // Menyimpan status login
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Mengambil status login
  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false; // Default false
  }
}