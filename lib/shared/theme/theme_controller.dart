import 'package:flutter/material.dart';

import '../services/preference_service.dart';

/// Holds [ThemeMode] and persists it via [PreferenceService].
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs);

  final PreferenceService _prefs;
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final raw = await _prefs.getThemeMode();
    _mode = _parse(raw);
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setThemeMode(value);
  }

  Future<void> setModeFromString(String raw) => setMode(_parse(raw));

  static ThemeMode _parse(String raw) => switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
