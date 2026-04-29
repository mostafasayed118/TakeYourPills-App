import 'package:shared_preferences/shared_preferences.dart';

/// Service for storing and retrieving app preferences.
///
/// Used for persisting user settings like notification preferences,
/// theme mode, quiet hours, etc.
abstract class PreferenceService {
  /// Get a string value for the given [key].
  /// Returns [defaultValue] if the key doesn't exist.
  Future<String?> getString(String key, {String? defaultValue});

  /// Set a string value for the given [key].
  Future<void> setString(String key, String value);

  /// Get an integer value for the given [key].
  /// Returns [defaultValue] if the key doesn't exist.
  Future<int?> getInt(String key, {int? defaultValue});

  /// Set an integer value for the given [key].
  Future<void> setInt(String key, int value);

  /// Get a boolean value for the given [key].
  /// Returns [defaultValue] if the key doesn't exist.
  Future<bool?> getBool(String key, {bool? defaultValue});

  /// Set a boolean value for the given [key].
  Future<void> setBool(String key, bool value);

  /// Remove the value for the given [key].
  Future<void> remove(String key);

  /// Remove all stored preferences.
  Future<void> clear();
}

/// Implementation of [PreferenceService] using SharedPreferences.
class PreferenceServiceImpl implements PreferenceService {
  static const String _notificationsEnabled = 'notifications_enabled';
  static const String _quietHoursStart = 'quiet_hours_start';
  static const String _quietHoursEnd = 'quiet_hours_end';
  static const String _defaultSnoozeMinutes = 'default_snooze_minutes';
  static const String _themeMode = 'theme_mode';
  static const String _fontSizeMultiplier = 'font_size_multiplier';
  static const String _onboardingComplete = 'onboarding_complete';

  late final SharedPreferences _prefs;

  PreferenceServiceImpl._();

  static final PreferenceServiceImpl _instance = PreferenceServiceImpl._();
  factory PreferenceServiceImpl() => _instance;

  /// Initialize the service. Must be called before any other method.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> getString(String key, {String? defaultValue}) async {
    return _prefs.getString(key) ?? defaultValue;
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<int?> getInt(String key, {int? defaultValue}) async {
    return _prefs.getInt(key) ?? defaultValue;
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<bool?> getBool(String key, {bool? defaultValue}) async {
    return _prefs.getBool(key) ?? defaultValue;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Convenience getters/setters for typed preferences

  Future<void> setNotificationsEnabled(bool value) async =>
      await _prefs.setBool(_notificationsEnabled, value);

  Future<bool> getNotificationsEnabled() async =>
      _prefs.getBool(_notificationsEnabled) ?? true;

  Future<void> setQuietHoursStart(int value) async =>
      await _prefs.setInt(_quietHoursStart, value);

  Future<int> getQuietHoursStart() async =>
      _prefs.getInt(_quietHoursStart) ?? 1380; // 23:00 in minutes

  Future<void> setQuietHoursEnd(int value) async =>
      await _prefs.setInt(_quietHoursEnd, value);

  Future<int> getQuietHoursEnd() async =>
      _prefs.getInt(_quietHoursEnd) ?? 420; // 07:00 in minutes

  Future<void> setDefaultSnoozeMinutes(int value) async =>
      await _prefs.setInt(_defaultSnoozeMinutes, value);

  Future<int> getDefaultSnoozeMinutes() async =>
      _prefs.getInt(_defaultSnoozeMinutes) ?? 10;

  Future<void> setThemeMode(String value) async =>
      await _prefs.setString(_themeMode, value);

  Future<String> getThemeMode() async =>
      _prefs.getString(_themeMode) ?? 'system';

  Future<void> setFontSizeMultiplier(double value) async =>
      await _prefs.setDouble(_fontSizeMultiplier, value);

  Future<double> getFontSizeMultiplier() async =>
      _prefs.getDouble(_fontSizeMultiplier) ?? 1.0;

  Future<void> setOnboardingComplete(bool value) async =>
      await _prefs.setBool(_onboardingComplete, value);

  Future<bool> getOnboardingComplete() async =>
      _prefs.getBool(_onboardingComplete) ?? false;
}
