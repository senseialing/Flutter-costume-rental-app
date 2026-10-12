import 'package:flutter/material.dart';

/// Manajer tema aplikasi.
///
/// Saat ini aplikasi hanya menggunakan tema gelap ("Neo-Tokyo Cosplay
/// Studio"). Kelas ini disediakan sebagai titik pusat bila di masa
/// depan diperlukan dukungan tema terang/gelap yang bisa di-toggle.
class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

