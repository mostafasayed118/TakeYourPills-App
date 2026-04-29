import 'package:drift/drift.dart';
import 'package:takeyourpills_healthcare_app/data/database/app_database.dart';
import 'package:takeyourpills_healthcare_app/data/database/mappers/medication_mapper.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/entities/schedule.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'mappers/schedule_mapper.dart';
import 'mappers/dose_log_mapper.dart';

class MedicationLocalDatasource {
  final AppDatabase _db;

  MedicationLocalDatasource(this._db);

  // Medications
  Future<List<Medication>> getAllMedications() async {
    final models = await _db.getAllMedications();
    return MedicationMapper.toEntityList(models);
  }

  Future<Medication?> getMedicationById(int id) async {
    final model = await _db.getMedicationById(id);
    return model != null ? MedicationMapper.toEntity(model) : null;
  }

  Future<int> createMedication(Medication medication) async {
    final model = MedicationMapper.toModel(medication);
    return await _db.createMedication(model);
  }

  Future<int> updateMedication(Medication medication) async {
    final model = MedicationMapper.toModel(medication);
    return await _db.updateMedication(model);
  }

  Future<int> deleteMedication(int id) async {
    return await _db.deleteMedication(id);
  }

  Future<List<Medication>> getActiveMedications() async {
    final models = await _db.getActiveMedications();
    return MedicationMapper.toEntityList(models);
  }

  // Schedules
  Future<List<Schedule>> getSchedulesForMedication(int medicationId) async {
    final models = await _db.getSchedulesForMedication(medicationId);
    return models.map(ScheduleMapper.toEntity).toList();
  }

  Future<int> createSchedule(Schedule schedule) async {
    final companion = ScheduleMapper.toCompanion(schedule);
    return await _db.createSchedule(companion);
  }

  Future<int> updateSchedule(Schedule schedule) async {
    final companion = ScheduleMapper.toCompanion(schedule);
    return await _db.updateSchedule(companion);
  }

  Future<int> deleteSchedule(int id) async {
    return await _db.deleteSchedule(id);
  }

  Future<int> deleteSchedulesForMedication(int medicationId) async {
    return await _db.deleteSchedulesForMedication(medicationId);
  }

  // Dose Logs
  Future<List<DoseLog>> getDoseLogsForMedication(int medicationId) async {
    final models = await _db.getDoseLogsForMedication(medicationId);
    return models.map(DoseLogMapper.toEntity).toList();
  }

  Future<int> createDoseLog(DoseLog doseLog) async {
    final companion = DoseLogMapper.toCompanion(doseLog);
    return await _db.createDoseLog(companion);
  }

  Future<List<DoseLog>> getDoseLogsForDateRange(DateTime start, DateTime end) async {
    final models = await _db.getDoseLogsForDateRange(start, end);
    return models.map(DoseLogMapper.toEntity).toList();
  }

  // Refill Tracking
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
      return await _db.updateRefillTracking(companion);
    } else {
      return await _db.createRefillTracking(companion);
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
      return await _db.updateRefillTracking(companion);
    }
    return 0;
  }

  Future<({int quantity, int threshold})?> getRefillInfo(int medicationId) async {
    final tracking = await _db.getRefillTrackingForMedication(medicationId);
    if (tracking == null) return null;
    return (quantity: tracking.currentQuantity, threshold: tracking.refillThreshold);
  }

  // Stream of all medications for real-time updates
  Stream<List<Medication>> watchAllMedications() {
    return _db.select(_db.medications).watch().map((rows) {
      return rows.map((row) => MedicationMapper.toEntity(row.readTable(_db.medications))).toList();
    });
  }

  // Batch operations
  Future<void> bulkInsertMedications(List<Medication> medications) async {
    return _db.batch((batch) {
      for (final med in medications) {
        final model = MedicationMapper.toModel(med);
        batch.insert(_db.medications, model);
      }
    });
  }
}
