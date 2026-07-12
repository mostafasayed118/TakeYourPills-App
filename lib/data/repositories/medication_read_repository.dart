import '../../core/entities/dose_log.dart';
import '../../core/entities/medication.dart';
import '../../core/entities/schedule.dart';
import '../../core/error/result.dart';

/// Query interface for medication data operations (ISP principle).
/// Contains only read/fetch methods.
abstract class MedicationReadRepository {
  // Medications
  Future<Result<List<Medication>>> getAllMedications();
  Future<Result<Medication?>> getMedicationById(int id);
  Future<Result<List<Medication>>> getActiveMedications();
  Stream<Result<List<Medication>>> watchAllMedications();

  // Schedules
  Future<Result<List<Schedule>>> getSchedulesForMedication(int medicationId);

  // Dose Logs
  Future<Result<List<DoseLog>>> getDoseLogsForMedication(int medicationId);
  Future<Result<List<DoseLog>>> getDoseLogsForDateRange(
    DateTime start,
    DateTime end,
  );

  // Refill Tracking
  Future<Result<({int quantity, int threshold})?>> getRefillInfo(
    int medicationId,
  );
}
