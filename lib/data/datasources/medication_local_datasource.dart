import 'package:drift/drift.dart';

import '../../core/entities/dose_log.dart';
import '../../core/entities/medication.dart';
import '../../core/entities/schedule.dart';
import '../database/app_database.dart';
import '../database/mappers/dose_log_mapper.dart';
import '../database/mappers/medication_mapper.dart';
import '../database/mappers/schedule_mapper.dart';

/// Local data source for medication-related operations.
///
/// Bridges the gap between the Drift database layer and the
/// domain entity layer using mappers for type conversion.
class MedicationLocalDatasource {

  MedicationLocalDatasource(this._db);
  final AppDatabase _db;

  // ── Medications ──────────────────────────────────────────────

  Future<List<Medication>> getAllMedications() async {
    final models = await _db.getAllMedications();
    return MedicationMapper.toEntityList(models);
  }

  Future<Medication?> getMedicationById(int id) async {
    final model = await _db.getMedicationById(id);
    return model != null ? MedicationMapper.toEntity(model) : null;
  }

  Future<int> createMedication(Medication medication) async {
    final companion = MedicationMapper.toCreateCompanion(medication);
    return _db.createMedication(companion);
  }

  Future<int> updateMedication(Medication medication) async {
    final companion = MedicationMapper.toUpdateCompanion(medication);
    return _db.updateMedicationRow(companion);
  }

  Future<int> deleteMedication(int id) async {
    await _db.deleteSchedulesForMedication(id);
    await _db.deleteDoseLogsForMedication(id);
    return _db.deleteMedication(id);
  }

  Future<List<Medication>> getActiveMedications() async {
    final models = await _db.getActiveMedications();
    return MedicationMapper.toEntityList(models);
  }

  /// Watch all medications as a reactive stream.
  Stream<List<Medication>> watchAllMedications() => _db.watchAllMedications().map(MedicationMapper.toEntityList);

  /// Batch insert multiple medications in a single transaction.
  Future<void> bulkInsertMedications(List<Medication> medications) async =>
      _db.batch((batch) {
        for (final med in medications) {
          final companion = MedicationMapper.toCreateCompanion(med);
          batch.insert(_db.medications, companion);
        }
      });

  // ── Schedules ────────────────────────────────────────────────

  Future<List<Schedule>> getSchedulesForMedication(int medicationId) async {
    final models = await _db.getSchedulesForMedication(medicationId);
    return ScheduleMapper.toEntityList(models);
  }

  Future<int> createSchedule(Schedule schedule) async {
    final companion = ScheduleMapper.toCompanion(schedule);
    return _db.createSchedule(companion);
  }

  Future<int> updateSchedule(Schedule schedule) async {
    final companion = ScheduleMapper.toCompanion(schedule);
    return _db.updateScheduleRow(companion);
  }

  Future<int> deleteSchedule(int id) async => _db.deleteSchedule(id);

  Future<int> deleteSchedulesForMedication(int medicationId) async => _db.deleteSchedulesForMedication(medicationId);

  // ── Dose Logs ────────────────────────────────────────────────

  Future<List<DoseLog>> getDoseLogsForMedication(int medicationId) async {
    final models = await _db.getDoseLogsForMedication(medicationId);
    return DoseLogMapper.toEntityList(models);
  }

  Future<int> createDoseLog(DoseLog doseLog) async {
    final companion = DoseLogMapper.toCompanion(doseLog);
    return _db.createDoseLog(companion);
  }

  Future<List<DoseLog>> getDoseLogsForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final models = await _db.getDoseLogsForDateRange(start, end);
    return DoseLogMapper.toEntityList(models);
  }

  // ── Refill Tracking ──────────────────────────────────────────

  Future<int> createOrUpdateRefillTracking({
    required int medicationId,
    required int currentQuantity,
    required int refillThreshold,
    DateTime? lastRefillDate,
    String? notes,
  }) async {
    final existing = await _db.getRefillTrackingForMedication(medicationId);
    final companion = RefillTrackingCompanion(
      medicationId: Value(medicationId),
      currentQuantity: Value(currentQuantity),
      refillThreshold: Value(refillThreshold),
      lastRefillDate: Value(lastRefillDate),
      notes: Value(notes),
    );
    if (existing != null) {
      return _db.updateRefillTracking(companion);
    } else {
      return _db.createRefillTracking(companion);
    }
  }

  Future<int> updateCurrentQuantity(int medicationId, int newQuantity) async {
    final existing = await _db.getRefillTrackingForMedication(medicationId);
    if (existing != null) {
      final companion = RefillTrackingCompanion(
        medicationId: Value(medicationId),
        currentQuantity: Value(newQuantity),
        refillThreshold: Value(existing.refillThreshold),
        lastRefillDate: Value(existing.lastRefillDate),
        notes: Value(existing.notes),
      );
      return _db.updateRefillTracking(companion);
    }
    return 0;
  }

  Future<({int quantity, int threshold})?> getRefillInfo(
    int medicationId,
  ) async {
    final tracking = await _db.getRefillTrackingForMedication(medicationId);
    if (tracking == null) return null;
    return (
      quantity: tracking.currentQuantity,
      threshold: tracking.refillThreshold,
    );
  }
}
