// App-wide constants and configuration

class AppConstants {
  // General
  static const String appName = 'TakeYourPills';
  static const int maxMedications = 50;
  static const int defaultSnoozeMinutes = 30;
  static const int missedDoseHoursThreshold = 3; // hours after which a dose is considered missed
  static const int notificationScheduleWindowDays = 30; // schedule notifications this many days ahead

  // Refill tracking defaults
  static const int defaultRefillThreshold = 10;
  static const int defaultRefillReminderDaysBefore = 7;

  // Adherence
  static const double goodAdherenceThreshold = 0.8; // 80%

  // Notification
  static const String notificationChannelMedication = 'medication_reminders';
  static const String notificationChannelRefill = 'refill_alerts';
  static const String notificationChannelGeneral = 'general';

  // Secure storage keys
  static const String secureStorageProviderName = 'provider_name';
  static const String secureStorageProviderContact = 'provider_contact';

  // Preferences keys
  static const String prefKeyOnboardingComplete = 'onboarding_complete';
  static const String prefKeyNotificationsEnabled = 'notifications_enabled';
  static const String prefKeyQuietHoursStart = 'quiet_hours_start';
  static const String prefKeyQuietHoursEnd = 'quiet_hours_end';
  static const String prefKeyDefaultSnoozeMinutes = 'default_snooze_minutes';
  static const String prefKeyNotificationSound = 'notification_sound';
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyFontSizeMultiplier = 'font_size_multiplier';
}
