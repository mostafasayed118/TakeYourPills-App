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

    return DashboardSummary(
      activeMedications: activeMeds,
      takenToday: takenToday,
      totalToday: totalToday,
      adherencePercent: adherencePercent,
      nextDose: nextDose,
      nextDoseTime: nextDoseTime,
      upcomingMedications: upcoming.take(3).toList(),
    );
  }
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
  });

  final List<Medication> activeMedications;
  final int takenToday;
  final int totalToday;
  final double adherencePercent;
  final Medication? nextDose;
  final DateTime? nextDoseTime;
  final List<Medication> upcomingMedications;
}
