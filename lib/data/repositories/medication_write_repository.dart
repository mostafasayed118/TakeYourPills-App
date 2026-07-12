import '../../core/entities/dose_log.dart';
import '../../core/entities/medication.dart';
import '../../core/entities/schedule.dart';
import '../../core/error/result.dart';

/// Command interface for medication data operations (ISP principle).
/// Contains only write/mutation methods.
abstract class MedicationWriteRepository {
  // Medications
  Future<Result<int>> createMedication(Medication medication);
  Future<Result<int>> updateMedication(Medication medication);
  Future<Result<int>> deleteMedication(int id);
  Future<Result<void>> bulkInsertMedications(List<Medication> medications);

  // Schedules
  Future<Result<int>> createSchedule(Schedule schedule);
  Future<Result<int>> updateSchedule(Schedule schedule);
  Future<Result<int>> deleteSchedule(int id);
  Future<Result<int>> deleteSchedulesForMedication(int medicationId);

  // Dose Logs
  Future<Result<int>> createDoseLog(DoseLog doseLog);

  // Refill Tracking
  Future<Result<int>> createOrUpdateRefillTracking({
    required int medicationId,
    required int currentQuantity,
    required int refillThreshold,
    DateTime? lastRefillDate,
    String? notes,
  });

  Future<Result<int>> updateCurrentQuantity(int medicationId, int newQuantity);
}
