import 'dart:convert';

import '../../core/entities/medication.dart';
import 'notification_service.dart';
import 'reminder_scheduler_service.dart';

/// Concrete reminder scheduler that converts medication schedules
/// into notification instances and manages their lifecycle.
class ReminderSchedulerImpl implements ReminderSchedulerService {

  ReminderSchedulerImpl({required NotificationService notificationService})
    : _notificationService = notificationService;
  final NotificationService _notificationService;

  @override
  Future<void> scheduleForMedication(Medication medication) async {
    if (medication.isPaused) return;

    final schedules = await _parseSchedules(medication);
    if (schedules.isEmpty) return;

    final occurrences = _generateOccurrences(
      schedules,
      medication.frequencyType,
      medication.frequencyDays,
      daysAhead: 30,
    );

    var notificationId = 0;
    for (final scheduledTime in occurrences) {
      final doseId = _computeDoseId(
        medication.id,
        scheduledTime,
        notificationId,
      );

      await _notificationService.scheduleNotification(
        id: doseId,
        medicationId: medication.id,
        doseId: doseId,
        scheduledTime: scheduledTime,
        title: 'Time for ${medication.name}',
        body: '${medication.dosageAmount} ${medication.dosageUnit}',
        payload: '${medication.id},$doseId,${scheduledTime.toIso8601String()}',
      );
      notificationId++;
    }
  }

  @override
  Future<void> rescheduleForMedication(Medication medication) async {
    await cancelAllForMedication(medication.id);
    await scheduleForMedication(medication);
  }

  @override
  Future<void> cancelAllForMedication(int medicationId) async {
    final pending = await _notificationService.getPendingNotifications();
    for (final notification in pending) {
      if (notification.payload != null) {
        final parts = notification.payload!.split(',');
        if (parts.isNotEmpty) {
          final medId = int.tryParse(parts[0]);
          if (medId == medicationId) {
            await _notificationService.cancelNotification(notification.id);
          }
        }
      }
    }
  }

  @override
  Future<void> cancelReminder(int notificationId) async {
    await _notificationService.cancelNotification(notificationId);
  }

  @override
  Future<void> cancelAll() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Parse schedule times from medication JSON scheduleTimes field.
  Future<List<DateTime>> _parseSchedules(Medication medication) async {
    final schedules = <DateTime>[];
    try {
      final times = List<dynamic>.from(
        medication.scheduleTimes.isEmpty
            ? []
            : List.from(
                medication.scheduleTimes
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .map((s) {
                      final parts = s.split(':');
                      final hour = int.tryParse(parts[0]) ?? 0;
                      final minute = int.tryParse(parts[1]) ?? 0;
                      return DateTime(
                        2000, // Dummy year - we only care about time of day
                        1,
                        1,
                        hour,
                        minute,
                      );
                    }),
              ),
      );
      schedules.addAll(times.cast<DateTime>());
    } catch (_) {
      // Fallback: no schedules
    }
    return schedules;
  }

  /// Generate future occurrence times for a medication.
  List<DateTime> _generateOccurrences(
    List<DateTime> schedules,
    String frequencyType,
    String frequencyDaysJson, {
    required int daysAhead,
  }) {
    final occurrences = <DateTime>[];
    final now = DateTime.now();
    final limitDate = DateTime(
      now.year,
      now.month,
      now.day + daysAhead,
      now.hour,
      now.minute,
    );

    for (final schedule in schedules) {
      final hour = schedule.hour;
      final minute = schedule.minute;

      for (var dayOffset = 0; dayOffset <= daysAhead; dayOffset++) {
        final candidate = DateTime(
          now.year,
          now.month,
          now.day + dayOffset,
          hour,
          minute,
        );

        if (candidate.isBefore(now)) continue;
        if (!candidate.isBefore(limitDate)) break;

        final shouldInclude = _shouldIncludeForFrequency(
          frequencyType,
          frequencyDaysJson,
          candidate,
        );
        if (shouldInclude) {
          occurrences.add(candidate);
        }
      }
    }

    occurrences.sort();
    return occurrences;
  }

  /// Determine if a candidate date should be included based on frequency.
  bool _shouldIncludeForFrequency(
    String frequencyType,
    String frequencyDaysJson,
    DateTime candidate,
  ) {
    switch (frequencyType) {
      case 'daily':
        return true;
      case 'weekly':
        return true;
      case 'specific_days':
        try {
          final daysList = List<dynamic>.from(
            frequencyDaysJson.isEmpty
                ? []
                : List.from(jsonDecode(frequencyDaysJson)),
          );
          final weekday = candidate.weekday; // 1=Monday, 7=Sunday
          return daysList.contains(weekday);
        } catch (_) {
          return false;
        }
      case 'as_needed':
        return false; // As-needed meds don't have automatic reminders
      default:
        return true;
    }
  }

  /// Compute a deterministic notification ID.
  int _computeDoseId(int medicationId, DateTime scheduledTime, int sequence) => (medicationId * 1000000) +
        (scheduledTime.millisecondsSinceEpoch ~/ 1000) +
        sequence;
}
