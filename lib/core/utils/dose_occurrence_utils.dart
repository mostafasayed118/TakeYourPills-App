import '../entities/dose_log.dart';
import '../entities/medication.dart';
import 'schedule_parser.dart';

/// A scheduled dose instance for calendar / progress views.
class DoseOccurrence {
  const DoseOccurrence({
    required this.medication,
    required this.scheduledTime,
  });

  final Medication medication;
  final DateTime scheduledTime;
}

/// Builds local-time dose occurrences for active medications in [rangeStart, rangeEnd).
List<DoseOccurrence> occurrencesForRange({
  required List<Medication> medications,
  required DateTime rangeStart,
  required DateTime rangeEnd,
}) {
  final start = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
  final end = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
  final results = <DoseOccurrence>[];

  for (final med in medications) {
    if (med.isPaused) continue;
    if (med.frequencyType == 'as_needed') continue;

    final times = parseScheduleTimes(med.scheduleTimes);
    if (times.isEmpty) continue;

    for (var day = start;
        day.isBefore(end);
        day = DateTime(day.year, day.month, day.day + 1)) {
      if (!_includesDay(med, day)) continue;
      for (final t in times) {
        results.add(
          DoseOccurrence(
            medication: med,
            scheduledTime: DateTime(
              day.year,
              day.month,
              day.day,
              t.hour,
              t.minute,
            ),
          ),
        );
      }
    }
  }

  results.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  return results;
}

bool _includesDay(Medication med, DateTime day) {
  switch (med.frequencyType) {
    case 'specific_days':
      try {
        final raw = med.frequencyDays.trim();
        if (raw.isEmpty || raw == '[]') return false;
        final list = raw.startsWith('[')
            ? (raw
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((s) => int.tryParse(s.trim()))
                .whereType<int>()
                .toList())
            : <int>[];
        // Support both 1–7 (DateTime.weekday) and 0–6 encodings.
        return list.contains(day.weekday) || list.contains(day.weekday % 7);
      } catch (_) {
        return false;
      }
    case 'as_needed':
      return false;
    default:
      return true;
  }
}

/// Whether a dose log matches an occurrence (same med, within ±30 min).
bool logMatchesOccurrence(DoseLog log, DoseOccurrence occ) {
  if (log.medicationId != occ.medication.id) return false;
  final scheduled = DateTime.tryParse(log.scheduledTime);
  if (scheduled == null) return false;
  final diff = scheduled.difference(occ.scheduledTime).inMinutes.abs();
  return diff <= 30;
}

String formatTimeOfDay(DateTime dt) {
  final h = dt.hour;
  final m = dt.minute.toString().padLeft(2, '0');
  final period = h >= 12 ? 'PM' : 'AM';
  final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$hour12:$m $period';
}
