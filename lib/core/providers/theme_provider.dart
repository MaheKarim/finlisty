import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme (light/dark/system)
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'system';
    _themeMode = _parseThemeMode(themeString);
    notifyListeners();
  }

  /// Change app theme
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString().split('.').last);
    _themeMode = mode;
    notifyListeners();
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String modeString) {
    switch (modeString.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Check if dark mode is active
  bool isDarkMode(BuildContext context) {
    return _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }
}
