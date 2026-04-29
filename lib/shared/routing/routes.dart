class AppRoutes {
  // Main routes
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';
  static const String medications = '/medications';
  static const String addMedication = '/add-medication';
  static const String medicationDetail = '/medication/:id';
  static const String calendar = '/calendar';
  static const String history = '/history';
  static const String progress = '/progress';
  static const String settings = '/settings';
  static const String messaging = '/messaging';

  // Settings sub-routes
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsAppearance = '/settings/appearance';
  static const String settingsAbout = '/settings/about';

  // Messaging sub-routes
  static const String conversation = '/messaging/:threadId';
  static const String composer = '/messaging/compose';

  // Hidden routes
  static const String reminderActionSheet = '/reminder-action-sheet';
  static const String refillTracker = '/refill-tracker';
}

class RouteNames {
  static const String dashboard = 'Dashboard';
  static const String medications = 'Medications';
  static const String calendar = 'Calendar';
  static const String history = 'History';
  static const String progress = 'Progress';
  static const String settings = 'Settings';
}
