import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/entities/schedule.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/data/datasources/medication_local_datasource.dart';

/// Abstract contract for medication data operations.
///
/// This interface decouples the domain/presentation layers from
/// the concrete data implementation, enabling testability.
abstract class MedicationRepository {
  // Medications
  Future<List<Medication>> getAllMedications();
  Future<Medication?> getMedicationById(int id);
  Future<int> createMedication(Medication medication);
  Future<int> updateMedication(Medication medication);
  Future<int> deleteMedication(int id);
  Future<List<Medication>> getActiveMedications();
  Future<void> bulkInsertMedications(List<Medication> medications);
  Stream<List<Medication>> watchAllMedications();

  // Schedules
  Future<List<Schedule>> getSchedulesForMedication(int medicationId);
  Future<int> createSchedule(Schedule schedule);
  Future<int> updateSchedule(Schedule schedule);
  Future<int> deleteSchedule(int id);
  Future<int> deleteSchedulesForMedication(int medicationId);

  // Dose Logs
  Future<List<DoseLog>> getDoseLogsForMedication(int medicationId);
  Future<int> createDoseLog(DoseLog doseLog);
  Future<List<DoseLog>> getDoseLogsForDateRange(DateTime start, DateTime end);

  // Refill Tracking
  Future<int> createOrUpdateRefillTracking({
    required int medicationId,
    required int currentQuantity,
    required int refillThreshold,
    DateTime? lastRefillDate,
    String? notes,
  });
  Future<int> updateCurrentQuantity(int medicationId, int newQuantity);
  Future<({int quantity, int threshold})?> getRefillInfo(int medicationId);
}

/// Concrete implementation of [MedicationRepository] using local datasource.
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDatasource _localDatasource;

  MedicationRepositoryImpl(this._localDatasource);

  @override
  Future<List<Medication>> getAllMedications() {
    return _localDatasource.getAllMedications();
  }

  @override
  Future<Medication?> getMedicationById(int id) {
    return _localDatasource.getMedicationById(id);
  }

  @override
  Future<int> createMedication(Medication medication) {
    return _localDatasource.createMedication(medication);
  }

  @override
  Future<int> updateMedication(Medication medication) {
    return _localDatasource.updateMedication(medication);
  }

  @override
  Future<int> deleteMedication(int id) {
    return _localDatasource.deleteMedication(id);
  }

  @override
  Future<List<Medication>> getActiveMedications() {
    return _localDatasource.getActiveMedications();
  }

  @override
  Future<void> bulkInsertMedications(List<Medication> medications) {
    return _localDatasource.bulkInsertMedications(medications);
  }

  @override
  Stream<List<Medication>> watchAllMedications() {
    return _localDatasource.watchAllMedications();
  }

  @override
  Future<List<Schedule>> getSchedulesForMedication(int medicationId) {
    return _localDatasource.getSchedulesForMedication(medicationId);
  }

  @override
  Future<int> createSchedule(Schedule schedule) {
    return _localDatasource.createSchedule(schedule);
  }

  @override
  Future<int> updateSchedule(Schedule schedule) {
    return _localDatasource.updateSchedule(schedule);
  }

  @override
  Future<int> deleteSchedule(int id) {
    return _localDatasource.deleteSchedule(id);
  }

  @override
  Future<int> deleteSchedulesForMedication(int medicationId) {
    return _localDatasource.deleteSchedulesForMedication(medicationId);
  }

  @override
  Future<List<DoseLog>> getDoseLogsForMedication(int medicationId) {
    return _localDatasource.getDoseLogsForMedication(medicationId);
  }

  @override
  Future<int> createDoseLog(DoseLog doseLog) {
    return _localDatasource.createDoseLog(doseLog);
  }

  @override
  Future<List<DoseLog>> getDoseLogsForDateRange(DateTime start, DateTime end) {
    return _localDatasource.getDoseLogsForDateRange(start, end);
  }

  @override
  Future<int> createOrUpdateRefillTracking({
    required int medicationId,
    required int currentQuantity,
    required int refillThreshold,
    DateTime? lastRefillDate,
    String? notes,
  }) {
    return _localDatasource.createOrUpdateRefillTracking(
      medicationId: medicationId,
      currentQuantity: currentQuantity,
      refillThreshold: refillThreshold,
      lastRefillDate: lastRefillDate,
      notes: notes,
    );
  }

  @override
  Future<int> updateCurrentQuantity(int medicationId, int newQuantity) {
    return _localDatasource.updateCurrentQuantity(medicationId, newQuantity);
  }

  @override
  Future<({int quantity, int threshold})?> getRefillInfo(int medicationId) {
    return _localDatasource.getRefillInfo(medicationId);
  }
}
