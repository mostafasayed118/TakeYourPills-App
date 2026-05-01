import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/core/error/app_error.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:takeyourpills_healthcare_app/shared/routing/app_router.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service.dart';

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
      AppRouter.navigatorKey.currentContext!.go('/medication/$medicationId');
    }
  } catch (e) {
    // Silently fail in background
  }
}

/// Concrete implementation of NotificationService
/// using flutter_local_notifications and timezone.
class NotificationServiceImpl implements NotificationService {
  static final NotificationServiceImpl _instance =
      NotificationServiceImpl._internal();
  factory NotificationServiceImpl() => _instance;
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
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initSettings = InitializationSettings(
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
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    _location = tz.getLocation(timezoneInfo.identifier);
  }

  Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelMedicationReminders,
      'Medication Reminders',
      description: 'Reminders for scheduled medication doses',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidNotificationChannel refillChannel = AndroidNotificationChannel(
      _channelRefillAlerts,
      'Refill Alerts',
      description: 'Alerts for low medication stock',
      importance: Importance.defaultImportance,
      enableVibration: true,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(refillChannel);
  }

  @override
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await androidImplementation
          ?.areNotificationsEnabled();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final bool? granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return false;
  }

  @override
  Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await androidImplementation
          ?.areNotificationsEnabled();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final bool? granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: false);
      return granted ?? false;
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
      throw AppError.notification(
        message: 'Notification service not initialized',
      );
    }

    if (scheduledTime.isBefore(DateTime.now())) {
      throw AppError.notification(
        message: 'Cannot schedule notification in the past',
      );
    }

    // Schedule with timezone-aware time using zonedSchedule
    final tz.TZDateTime zonedTime = _tzScheduledTime(scheduledTime);

    await _notificationsPlugin.zonedSchedule(
      id: id,
      scheduledDate: zonedTime,
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
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
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelMedicationReminders,
          'Medication Reminders',
          channelDescription: 'Reminders for scheduled medication doses',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
          visibility: NotificationVisibility.public,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
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
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notificationsPlugin.pendingNotificationRequests();
  }

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

      // Create dose log - use id: 0 to let database auto-assign
      final doseLog = DoseLog(
        id: 0,
        medicationId: medicationId,
        scheduledTime: scheduledTime.toIso8601String(),
        status: DoseLogStatus.taken,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repository = GetIt.instance<MedicationRepository>();
      await repository.createDoseLog(doseLog);

      // Navigate to medication detail
      if (AppRouter.navigatorKey.currentContext != null) {
        AppRouter.navigatorKey.currentContext!.go('/medication/$medicationId');
      }
    } catch (e) {
      // Silently fail - notification tap is best-effort
    }
  }

  @override
  tz.Location get timeZoneLocation {
    if (_location == null) {
      throw AppError.notification(message: 'Timezone not initialized');
    }
    return _location!;
  }

  /// Request exact alarm permission on Android 14+
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    // Exact alarm permission is granted through system settings
    return true;
  }

  bool get isInitialized => _initialized;
}
