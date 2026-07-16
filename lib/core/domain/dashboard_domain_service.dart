import '../entities/dose_log.dart';
import '../entities/medication.dart';
import '../utils/schedule_parser.dart';

/// Pure computation for the dashboard summary.
///
/// Takes raw data (medications + dose logs) and computes derived values.
/// No repository calls — this is domain logic only.
class DashboardDomainService {
  /// Computes today's dashboard summary from active medications and dose logs.
  DashboardSummary computeToday({
    required List<Medication> medications,
    required List<DoseLog> todayDoseLogs,
  }) {
    final activeMeds = medications.where((m) => !m.isPaused).toList();
    final now = DateTime.now();

    var takenToday = 0;
    var totalToday = 0;
    Medication? nextDose;
    DateTime? nextDoseTime;
    final upcoming = <Medication>[];

    for (final med in activeMeds) {
      final schedules = parseScheduleTimes(med.scheduleTimes);
      totalToday += schedules.length;

      for (final time in schedules) {
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        if (scheduledDateTime.isAfter(now)) {
          if (nextDoseTime == null || scheduledDateTime.isBefore(nextDoseTime)) {
            nextDose = med;
            nextDoseTime = scheduledDateTime;
          }
        }
      }

      if (schedules.any((t) {
        final st = DateTime(now.year, now.month, now.day, t.hour, t.minute);
        return st.isAfter(now);
      })) {
        upcoming.add(med);
      }
    }

    takenToday = todayDoseLogs
        .where((log) => log.status == DoseLogStatus.taken)
        .length;

    final adherencePercent = totalToday > 0
        ? (takenToday / totalToday * 100).clamp(0.0, 100.0)
        : 0.0;

    upcoming.sort((a, b) {
      final aTimes = parseScheduleTimes(a.scheduleTimes);
      final bTimes = parseScheduleTimes(b.scheduleTimes);
      if (aTimes.isEmpty || bTimes.isEmpty) return 0;
      return aTimes.first.compareTo(bTimes.first);
    });

    // Build dose occurrences for quick logging
    final doseOccurrences = <ScheduledDose>[];
    for (final med in activeMeds) {
      final schedules = parseScheduleTimes(med.scheduleTimes);
      for (final time in schedules) {
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        final isTaken = todayDoseLogs.any((log) {
          if (log.medicationId != med.id) return false;
          if (log.status != DoseLogStatus.taken) return false;
          final logTime = DateTime.tryParse(log.scheduledTime);
          if (logTime == null) return false;
          return logTime.hour == time.hour && logTime.minute == time.minute;
        });

        doseOccurrences.add(ScheduledDose(
          medication: med,
          scheduledTime: scheduledDateTime,
          isTaken: isTaken,
        ));
      }
    }

    doseOccurrences.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    return DashboardSummary(
      activeMedications: activeMeds,
      takenToday: takenToday,
      totalToday: totalToday,
      adherencePercent: adherencePercent,
      nextDose: nextDose,
      nextDoseTime: nextDoseTime,
      upcomingMedications: upcoming.take(3).toList(),
      doseOccurrences: doseOccurrences,
    );
  }

  /// Computes streak data from historical dose logs.
  ///
  /// A "perfect day" is a day where all scheduled doses were taken.
  /// The streak is the number of consecutive perfect days ending today.
  StreakData computeStreak({
    required List<Medication> medications,
    required List<DoseLog> recentLogs,
  }) {
    final activeMeds = medications.where((m) => !m.isPaused).toList();
    if (activeMeds.isEmpty) {
      return const StreakData(currentStreak: 0, bestStreak: 0);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Build a map of date → (scheduled count, taken count)
    final dayMap = <DateTime, _DayCount>{};

    for (var i = 0; i < 30; i++) {
      final day = today.subtract(Duration(days: i));
      final dayEnd = day.add(const Duration(days: 1));
      var scheduled = 0;
      var taken = 0;

      for (final med in activeMeds) {
        final schedules = parseScheduleTimes(med.scheduleTimes);
        for (final time in schedules) {
          final st = DateTime(day.year, day.month, day.day, time.hour, time.minute);
          // Only count doses that were scheduled for this day
          if (st.isAfter(day.subtract(const Duration(seconds: 1))) &&
              st.isBefore(dayEnd)) {
            scheduled++;
            // Check if this dose was taken
            final wasTaken = recentLogs.any((log) {
              if (log.medicationId != med.id) return false;
              if (log.status != DoseLogStatus.taken) return false;
              final logTime = DateTime.tryParse(log.scheduledTime);
              if (logTime == null) return false;
              return logTime.year == day.year &&
                  logTime.month == day.month &&
                  logTime.day == day.day &&
                  logTime.hour == time.hour &&
                  logTime.minute == time.minute;
            });
            if (wasTaken) taken++;
          }
        }
      }

      if (scheduled > 0) {
        dayMap[day] = _DayCount(scheduled: scheduled, taken: taken);
      }
    }

    // Compute current streak (consecutive perfect days from today)
    var currentStreak = 0;
    for (var i = 0; i < 30; i++) {
      final day = today.subtract(Duration(days: i));
      final count = dayMap[day];
      if (count == null) continue; // No doses scheduled
      if (count.taken >= count.scheduled) {
        currentStreak++;
      } else {
        break;
      }
    }

    // Compute best streak from all available data
    var bestStreak = 0;
    var tempStreak = 0;
    for (var i = 29; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final count = dayMap[day];
      if (count == null) {
        tempStreak = 0;
        continue;
      }
      if (count.taken >= count.scheduled) {
        tempStreak++;
        if (tempStreak > bestStreak) {
          bestStreak = tempStreak;
        }
      } else {
        tempStreak = 0;
      }
    }

    return StreakData(
      currentStreak: currentStreak,
      bestStreak: bestStreak > currentStreak ? bestStreak : currentStreak,
    );
  }
}

/// A scheduled dose occurrence for quick logging.
class ScheduledDose {
  const ScheduledDose({
    required this.medication,
    required this.scheduledTime,
    required this.isTaken,
  });

  final Medication medication;
  final DateTime scheduledTime;
  final bool isTaken;

  /// Unique key for this dose occurrence.
  String get key => '${medication.id}_${scheduledTime.hour}_${scheduledTime.minute}';
}

/// Computed dashboard data — pure value, no side effects.
class DashboardSummary {
  const DashboardSummary({
    required this.activeMedications,
    required this.takenToday,
    required this.totalToday,
    required this.adherencePercent,
    this.nextDose,
    this.nextDoseTime,
    required this.upcomingMedications,
    this.doseOccurrences = const [],
  });

  final List<Medication> activeMedications;
  final int takenToday;
  final int totalToday;
  final double adherencePercent;
  final Medication? nextDose;
  final DateTime? nextDoseTime;
  final List<Medication> upcomingMedications;
  final List<ScheduledDose> doseOccurrences;
}

/// Streak data — current and best streak counts.
class StreakData {
  const StreakData({
    required this.currentStreak,
    required this.bestStreak,
  });

  final int currentStreak;
  final int bestStreak;

  /// Motivational message based on streak.
  String get message {
    if (currentStreak == 0) return 'Start your streak today!';
    if (currentStreak == 1) return 'Great start! Keep it going.';
    if (currentStreak < 7) return '$currentStreak days strong!';
    if (currentStreak < 30) return 'Amazing! $currentStreak days in a row!';
    if (currentStreak < 100) return 'Incredible! $currentStreak day streak!';
    return 'Legendary! $currentStreak days!';
  }

  /// Badge level based on streak.
  StreakBadgeLevel get badge {
    if (currentStreak >= 100) return StreakBadgeLevel.legendary;
    if (currentStreak >= 30) return StreakBadgeLevel.gold;
    if (currentStreak >= 7) return StreakBadgeLevel.silver;
    if (currentStreak >= 3) return StreakBadgeLevel.bronze;
    return StreakBadgeLevel.none;
  }
}

enum StreakBadgeLevel { none, bronze, silver, gold, legendary }

class _DayCount {
  const _DayCount({required this.scheduled, required this.taken});
  final int scheduled;
  final int taken;
}
