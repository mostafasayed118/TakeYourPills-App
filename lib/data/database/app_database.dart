import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/medications.dart';
import 'tables/schedules.dart';
import 'tables/dose_logs.dart';
import 'tables/refill_tracking.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Medications, Schedules, DoseLogs, RefillTracking])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing only
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(medications, medications.frequencyType);
        await m.addColumn(medications, medications.frequencyDays);
        await m.addColumn(medications, medications.frequencyInterval);
        await m.addColumn(medications, medications.scheduleTimes);
        await m.addColumn(medications, medications.startDate);
        await m.addColumn(medications, medications.endDate);
        await m.addColumn(medications, medications.instructions);
        await m.addColumn(medications, medications.pillsRemaining);
        await m.addColumn(medications, medications.refillThreshold);
      }
    },
  );

  // ── Medications ──────────────────────────────────────────────

  Future<int> createMedication(MedicationData medication) {
    return into(medications).insert(medication);
  }

  Future<int> updateMedicationRow(MedicationData medication) {
    return (update(medications)
          ..where((t) => t.id.equals(medication.id)))
        .write(medication);
  }

  Future<int> deleteMedication(int id) {
    return (delete(medications)..where((t) => t.id.equals(id))).go();
  }

  Future<MedicationData?> getMedicationById(int id) {
    return (select(medications)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<MedicationData>> getAllMedications() {
    return (select(medications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<List<MedicationData>> getActiveMedications() {
    return (select(medications)..where((t) => t.isPaused.equals(false))).get();
  }

  Stream<List<MedicationData>> watchAllMedications() {
    return (select(medications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ── Schedules ────────────────────────────────────────────────

  Future<int> createSchedule(SchedulesCompanion schedule) {
    return into(schedules).insert(schedule);
  }

  Future<int> updateScheduleRow(SchedulesCompanion schedule) {
    return (update(schedules)
          ..where((t) => t.id.equals(schedule.id.value)))
        .write(schedule);
  }

  Future<int> deleteSchedule(int id) {
    return (delete(schedules)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteSchedulesForMedication(int medicationId) {
    return (delete(schedules)
          ..where((t) => t.medicationId.equals(medicationId)))
        .go();
  }

  Future<List<ScheduleData>> getSchedulesForMedication(int medicationId) {
    return (select(schedules)
          ..where((t) => t.medicationId.equals(medicationId)))
        .get();
  }

  // ── Dose Logs ────────────────────────────────────────────────

  Future<int> createDoseLog(DoseLogsCompanion doseLog) {
    return into(doseLogs).insert(doseLog);
  }

  Future<List<DoseLogData>> getDoseLogsForMedication(int medicationId) {
    return (select(doseLogs)
          ..where((t) => t.medicationId.equals(medicationId)))
        .get();
  }

  Future<List<DoseLogData>> getDoseLogsForDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (select(doseLogs)
          ..where(
            (t) => t.scheduledTime
                .isBiggerOrEqualValue(start.toIso8601String()),
          )
          ..where(
            (t) => t.scheduledTime
                .isSmallerOrEqualValue(end.toIso8601String()),
          ))
        .get();
  }

  // ── Refill Tracking ──────────────────────────────────────────

  Future<int> createRefillTracking(RefillTrackingCompanion refill) {
    return into(refillTracking).insert(refill);
  }

  Future<int> updateRefillTracking(RefillTrackingCompanion refill) {
    return (update(refillTracking)
          ..where((t) => t.medicationId.equals(refill.medicationId.value)))
        .write(refill);
  }

  Future<RefillTrackingData?> getRefillTrackingForMedication(
    int medicationId,
  ) {
    return (select(refillTracking)
          ..where((t) => t.medicationId.equals(medicationId)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'takeyourpills.db'));
    return NativeDatabase(file);
  });
}
