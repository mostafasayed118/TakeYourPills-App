import '../entities/dose_log.dart';
import '../entities/medication.dart';
import '../error/result.dart';

/// Domain service for medication scheduling business logic.
/// Encapsulates core scheduling algorithms decoupled from presentation.
class MedicationScheduleService {
  const MedicationScheduleService();

  /// Parses schedule times from JSON string to list of DateTime.
  Result<List<DateTime>> parseScheduleTimes(String jsonTimes) {
    try {
      if (jsonTimes.isEmpty || jsonTimes == '[]') {
        return const ResultFailure('Empty schedule times');
      }
      final times = _parseJsonArray(jsonTimes);
      final parsed = <DateTime>[];
      for (final time in times) {
        final parts = time.split(':');
        if (parts.length != 2) {
          return ResultFailure('Invalid time format: $time');
        }
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour == null || minute == null) {
          return ResultFailure('Invalid time values: $time');
        }
        parsed.add(DateTime(0, 1, 1, hour, minute));
      }
      return Success(parsed);
    } catch (e) {
      return ResultFailure(e);
    }
  }

  /// Calculates adherence percentage for a date range.
  Result<double> calculateAdherence({
    required List<DoseLog> doseLogs,
    required List<Medication> medications,
    required DateTime date,
  }) {
    try {
      var expectedDoses = 0;
      var takenDoses = 0;

      for (final med in medications) {
        if (med.isPaused) continue;
        final dosesForMed = doseLogs
            .where((log) => log.medicationId == med.id)
            .toList();
        takenDoses += dosesForMed
            .where((log) => log.status == DoseLogStatus.taken)
            .length;

        final expectedPerDay = _getExpectedDosesPerDay(med);
        expectedDoses += expectedPerDay;
      }

      if (expectedDoses == 0) return const Success(1);
      return Success(takenDoses / expectedDoses);
    } catch (e) {
      return ResultFailure(e);
    }
  }

  /// Determines if a medication needs refill alert.
  Result<bool> needsRefillAlert(Medication medication) {
    try {
      if (medication.pillsRemaining == null ||
          medication.refillThreshold == null) {
        return const Success(false);
      }
      return Success(medication.pillsRemaining! <= medication.refillThreshold!);
    } catch (e) {
      return ResultFailure(e);
    }
  }

  /// Validates medication form data.
  Result<void> validateMedication(Medication medication) {
    if (medication.name.trim().isEmpty) {
      return const ResultFailure('Medication name is required');
    }
    if (medication.dosageAmount.isEmpty) {
      return const ResultFailure('Dosage amount is required');
    }
    final dosage = double.tryParse(medication.dosageAmount);
    if (dosage == null || dosage <= 0) {
      return const ResultFailure('Invalid dosage amount');
    }
    if (medication.scheduleTimes.isEmpty || medication.scheduleTimes == '[]') {
      return const ResultFailure('At least one schedule time is required');
    }
    return const Success(null);
  }

  int _getExpectedDosesPerDay(Medication med) {
    switch (med.frequencyType) {
      case 'daily':
        return med.scheduleTimes.isNotEmpty
            ? _parseJsonArray(med.scheduleTimes).length
            : 1;
      case 'weekly':
        return 1;
      case 'as_needed':
        return 0;
      case 'specific_days':
        return med.frequencyInterval;
      default:
        return 1;
    }
  }

  List<String> _parseJsonArray(String json) {
    final list = json
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '');
    return list
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
