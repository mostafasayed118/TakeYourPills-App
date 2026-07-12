import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service for handling local notifications.
abstract class NotificationService {
  /// Initialize the notification service.
  /// Must be called once at app startup after binding initialization.
  Future<void> init();

  /// Request notification permissions from the user.
  ///
  /// On Android 13+: requests [POST_NOTIFICATIONS].
  /// On Android 12+/14+: also requests exact-alarm permission when needed
  /// for reliable dose reminders.
  /// Returns true if notifications may be shown (exact alarm may still be denied).
  Future<bool> requestPermission();

  /// Request permission to schedule exact alarms (Android 12+/14+).
  /// Returns true on non-Android platforms or when already allowed.
  Future<bool> requestExactAlarmPermission();

  /// Whether the app can schedule exact alarms (dose times).
  Future<bool> canScheduleExactAlarms();

  /// Check if notification permission is granted.
  Future<bool> isPermissionGranted();

  /// Schedule a notification for a specific medication dose.
  /// [id] is a unique identifier for this notification.
  /// [medicationId] links to the medication.
  /// [doseId] links to the dose log entry.
  /// [scheduledTime] is when the notification should fire (local time).
  /// [title] is the notification title.
  /// [body] is the notification body.
  /// [payload] is additional data passed to the notification handler.
  Future<void> scheduleNotification({
    required int id,
    required int medicationId,
    required int doseId,
    required DateTime scheduledTime,
    required String title,
    required String body,
    String? payload,
  });

  /// Cancel a specific notification by its ID.
  Future<void> cancelNotification(int id);

  /// Cancel all pending notifications.
  Future<void> cancelAllNotifications();

  /// Get all pending notification requests.
  Future<List<PendingNotificationRequest>> getPendingNotifications();

  /// Reschedule all notifications (e.g., after timezone change or device reboot).
  Future<void> rescheduleAll();

  /// Handle when a notification is tapped by the user.
  Future<void> onNotificationTapped(NotificationResponse response);

  /// Get the timezone location for scheduling.
  tz.Location get timeZoneLocation;
}
