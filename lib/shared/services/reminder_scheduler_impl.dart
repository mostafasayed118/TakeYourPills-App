import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/entities/medication.dart';
import '../../core/error/result.dart';
import '../../data/repositories/medication_repository.dart';
import 'notification_service.dart';
import 'reminder_scheduler_service.dart';

/// Concrete reminder scheduler that converts medication schedules
/// into notification instances and manages their lifecycle.
class ReminderSchedulerImpl implements ReminderSchedulerService {
  ReminderSchedulerImpl({required NotificationService notificationService})
    : _notificationService = notificationService;
  final NotificationService _notificationService;

  /// How far ahead to materialize one-shot notifications.
  /// Kept modest so multi-med users stay under OS pending limits (~500).
  static const int _daysAhead = 14;

  @override
  Future<void> scheduleForMedication(Medication medication) async {
    if (medication.isPaused) return;

    final schedules = await _parseSchedules(medication);
    if (schedules.isEmpty) return;

    final occurrences = _generateOccurrences(
      schedules,
      medication.frequencyType,
      medication.frequencyDays,
      daysAhead: _daysAhead,
    );

    var sequence = 0;
    for (final scheduledTime in occurrences) {
      final doseId = computeNotificationId(
        medication.id,
        scheduledTime,
        sequence,
      );

      try {
        await _notificationService.scheduleNotification(
          id: doseId,
          medicationId: medication.id,
          doseId: doseId,
          scheduledTime: scheduledTime,
          title: 'Time for ${medication.name}',
          body: '${medication.dosageAmount} ${medication.dosageUnit}',
          payload:
              '${medication.id},$doseId,${scheduledTime.toIso8601String()}',
        );
      } on Object catch (e, st) {
        // Continue scheduling remaining doses; one failure must not wipe the rest.
        if (kDebugMode) {
          debugPrint('scheduleNotification failed for $doseId: $e\n$st');
        }
      }
      sequence++;
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

  @override
  Future<void> rebuildFromRepository(MedicationRepository repository) async {
    await cancelAll();
    final result = await repository.getActiveMedications();
    final medications = result.getOrNull() ?? const <Medication>[];
    for (final medication in medications) {
      try {
        await scheduleForMedication(medication);
      } on Object catch (e, st) {
        if (kDebugMode) {
          debugPrint(
            'rebuildFromRepository failed for med ${medication.id}: $e\n$st',
          );
        }
      }
    }
  }

  /// Parse schedule times from medication scheduleTimes field.
  Future<List<DateTime>> _parseSchedules(Medication medication) async {
    final schedules = <DateTime>[];
    try {
        final timeStrings = List<String>.from(jsonDecode(medication.scheduleTimes));
        if (timeStrings.isEmpty) return schedules;

      for (final s in timeStrings) {
        final cleaned = s.replaceAll('"', '').replaceAll("'", '');
        final parts = cleaned.split(':');
        if (parts.isEmpty) continue;
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
        if (hour < 0 || hour > 23 || minute < 0 || minute > 59) continue;
        schedules.add(DateTime(2000, 1, 1, hour, minute));
      }
    } catch (_) {
      // Fallback: no schedules
    }
    return schedules;
  }

  /// Generate future occurrence times for a medication (local calendar days).
  List<DateTime> _generateOccurrences(
    List<DateTime> schedules,
    String frequencyType,
    String frequencyDaysJson, {
    required int daysAhead,
  }) {
    final occurrences = <DateTime>[];
    final now = DateTime.now();
    // Exclusive end: end of the last local day in the window.
    final limitDate = DateTime(now.year, now.month, now.day + daysAhead + 1);

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

        if (!candidate.isAfter(now)) continue;
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
      case 'specific_days':
        try {
          final daysList = List<int>.from(jsonDecode(frequencyDaysJson));
          final weekday = candidate.weekday; // 1=Monday, 7=Sunday
          return daysList.contains(weekday);
        } catch (_) {
          return false;
        }
      case 'as_needed':
        return false; // As-needed meds don't have automatic reminders
      default:
        return true; // Fallback to daily
    }
  }

  /// Deterministic notification ID that fits in a signed 32-bit int (Android).
  ///
  /// Exposed for tests. Avoids wall-clock epoch math that overflows `int32`.
  static int computeNotificationId(
    int medicationId,
    DateTime scheduledTime,
    int sequence,
  ) {
    final hash = Object.hash(
      medicationId,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
      sequence,
    );
    // Positive 31-bit range required by Android notification IDs.
    return hash & 0x7fffffff;
  }
}
