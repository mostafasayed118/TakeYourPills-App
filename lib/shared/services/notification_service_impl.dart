import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/error/app_error.dart';
import '../routing/app_router.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundNotificationTapped(
  NotificationResponse response,
) async {
  // Background handler - simplified for isolate entry
  if (response.payload == null || response.payload!.isEmpty) return;

  try {
    final parts = response.payload!.split(',');
    if (parts.length < 3) return;

    final medicationId = int.tryParse(parts[0]);
    if (medicationId == null) return;

    // Navigate using global key if available
    if (AppRouter.navigatorKey.currentContext != null) {
      AppRouter.navigatorKey.currentContext!.go(
        '/reminder-action-sheet?medicationId=$medicationId&doseId=${parts[1]}&scheduledTime=${parts[2]}',
      );
    }
  } catch (e) {
    // Silently fail in background
  }
}

/// Concrete implementation of NotificationService
/// using flutter_local_notifications and timezone.
class NotificationServiceImpl implements NotificationService {
  factory NotificationServiceImpl() => _instance;
  NotificationServiceImpl._internal();
  static final NotificationServiceImpl _instance =
      NotificationServiceImpl._internal();

  late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  tz.Location? _location;
  bool _initialized = false;

  /// Android notification channel IDs
  static const String _channelMedicationReminders = 'medication_reminders';
  static const String _channelRefillAlerts = 'refill_alerts';

  @override
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone
    await _initializeTimezone();

    // Initialize notifications plugin
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // Permissions are requested explicitly via [requestPermission] during
    // onboarding / settings — avoid surprising the user at cold start.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationTapped,
    );

    // Setup notification channels
    await _setupNotificationChannels();

    _initialized = true;
  }

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(timezoneInfo.identifier);
      tz.setLocalLocation(location);
      _location = location;
    } on Object {
      // Device/OEM timezone strings are occasionally unknown to the TZ DB.
      tz.setLocalLocation(tz.UTC);
      _location = tz.UTC;
    }
  }

  Future<void> _setupNotificationChannels() async {
    const channel = AndroidNotificationChannel(
      _channelMedicationReminders,
      'Medication Reminders',
      description: 'Reminders for scheduled medication doses',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const refillChannel = AndroidNotificationChannel(
      _channelRefillAlerts,
      'Refill Alerts',
      description: 'Alerts for low medication stock',
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(refillChannel);
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin =>
      _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

  @override
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _androidPlugin;
      if (android == null) {
        return false;
      }

      // Android 13+ POST_NOTIFICATIONS prompt
      final notificationsGranted =
          await android.requestNotificationsPermission() ??
          await android.areNotificationsEnabled() ??
          false;

      // Exact alarms for reliable dose times (SCHEDULE_EXACT_ALARM)
      await requestExactAlarmPermission();

      return notificationsGranted;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    return false;
  }

  @override
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final android = _androidPlugin;
    if (android == null) {
      return false;
    }

    final canSchedule = await android.canScheduleExactNotifications() ?? false;
    if (canSchedule) {
      return true;
    }

    // Opens system exact-alarm settings for this app (Android 12+/14+)
    return await android.requestExactAlarmsPermission() ?? false;
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) {
      return true;
    }
    return await _androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  @override
  Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid) {
      return await _androidPlugin?.areNotificationsEnabled() ?? false;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      // iOS has no separate "check only" without requesting; treat as granted
      // when init requested permissions and app is running. Prefer storing
      // user choice in preferences for a stricter check later.
      return true;
    }

    return false;
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required int medicationId,
    required int doseId,
    required DateTime scheduledTime,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      throw const AppError.notification(
        message: 'Notification service not initialized',
      );
    }

    if (scheduledTime.isBefore(DateTime.now())) {
      throw const AppError.notification(
        message: 'Cannot schedule notification in the past',
      );
    }

    // Schedule with timezone-aware time using zonedSchedule
    final zonedTime = _tzScheduledTime(scheduledTime);

    // Prefer exact alarms for dose reliability; fall back if not granted.
    final exactOk = await canScheduleExactAlarms();
    final scheduleMode = exactOk
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    // One-shot schedule: the scheduler already materializes each occurrence.
    // Do NOT set matchDateTimeComponents — that would re-fire daily forever
    // and ignore specific_days / as_needed frequency rules.
    await _notificationsPlugin.zonedSchedule(
      id: id,
      scheduledDate: zonedTime,
      notificationDetails: _notificationDetails(),
      androidScheduleMode: scheduleMode,
      payload: payload ?? '$medicationId,$doseId,$scheduledTime',
      title: title,
      body: body,
    );
  }

  tz.TZDateTime _tzScheduledTime(DateTime scheduledTime) {
    final tzLocation = _location ?? tz.local;
    return tz.TZDateTime(
      tzLocation,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
      scheduledTime.second,
    );
  }

  NotificationDetails _notificationDetails() {
    // private: lock-screen shows redacted content until device unlocked —
    // reduces PHI leakage (medication names/doses) on shared devices.
    const androidDetails = AndroidNotificationDetails(
      _channelMedicationReminders,
      'Medication Reminders',
      channelDescription: 'Reminders for scheduled medication doses',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.private,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'medication_reminder',
    );

    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async =>
      _notificationsPlugin.pendingNotificationRequests();

  @override
  Future<void> rescheduleAll() async {
    await cancelAllNotifications();
  }

  @override
  Future<void> onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      // Parse payload: medicationId,doseId,timestamp
      final parts = payload.split(',');
      if (parts.length < 3) return;

      final medicationId = int.tryParse(parts[0]);
      final doseId = int.tryParse(parts[1]);
      final scheduledTime = DateTime.tryParse(parts[2]);

      if (medicationId == null || doseId == null || scheduledTime == null) {
        return;
      }

      // Navigate to reminder action sheet
      if (AppRouter.navigatorKey.currentContext != null) {
        AppRouter.navigatorKey.currentContext!.go(
          '/reminder-action-sheet?medicationId=$medicationId&doseId=$doseId&scheduledTime=${scheduledTime.toIso8601String()}',
        );
      }
    } catch (e) {
      // Silently fail - notification tap is best-effort
    }
  }

  @override
  tz.Location get timeZoneLocation {
    if (_location == null) {
      throw const AppError.notification(message: 'Timezone not initialized');
    }
    return _location!;
  }

  bool get isInitialized => _initialized;
}
