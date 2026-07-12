import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/dose_logs.dart';
import 'tables/medications.dart';
import 'tables/refill_tracking.dart';
import 'tables/schedules.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Medications, Schedules, DoseLogs, RefillTracking])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
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
      // schemaVersion 3: no structural changes (version bump for deploy hygiene).
      // Future migrations: add `if (from < N) { ... }` blocks only.
    },
  );

  Future<int> createMedication(MedicationData medication) => into(medications).insert(medication);

  Future<int> updateMedicationRow(MedicationData medication) => (update(
      medications,
    )..where((t) => t.id.equals(medication.id))).write(medication);

  Future<int> deleteMedication(int id) => (delete(medications)..where((t) => t.id.equals(id))).go();

  Future<MedicationData?> getMedicationById(int id) => (select(
      medications,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MedicationData>> getAllMedications() => (select(
      medications,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Future<List<MedicationData>> getActiveMedications() => (select(medications)..where((t) => t.isPaused.equals(false))).get();

  Stream<List<MedicationData>> watchAllMedications() => (select(
      medications,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<int> createSchedule(SchedulesCompanion schedule) => into(schedules).insert(schedule);

  Future<int> updateScheduleRow(SchedulesCompanion schedule) => (update(
      schedules,
    )..where((t) => t.id.equals(schedule.id.value))).write(schedule);

  Future<int> deleteSchedule(int id) => (delete(schedules)..where((t) => t.id.equals(id))).go();

  Future<int> deleteSchedulesForMedication(int medicationId) => (delete(
      schedules,
    )..where((t) => t.medicationId.equals(medicationId))).go();

  Future<List<ScheduleData>> getSchedulesForMedication(int medicationId) => (select(
      schedules,
    )..where((t) => t.medicationId.equals(medicationId))).get();

  Future<int> createDoseLog(DoseLogsCompanion doseLog) => into(doseLogs).insert(doseLog);

  Future<List<DoseLogData>> getDoseLogsForMedication(int medicationId) => (select(
      doseLogs,
    )..where((t) => t.medicationId.equals(medicationId))).get();

  Future<int> deleteDoseLogsForMedication(int medicationId) => (delete(
      doseLogs,
    )..where((t) => t.medicationId.equals(medicationId))).go();

  Future<List<DoseLogData>> getDoseLogsForDateRange(
    DateTime start,
    DateTime end,
  ) => (select(doseLogs)
          ..where(
            (t) =>
                t.scheduledTime.isBiggerOrEqualValue(start.toIso8601String()),
          )
          ..where(
            (t) => t.scheduledTime.isSmallerOrEqualValue(end.toIso8601String()),
          ))
        .get();

  Future<int> createRefillTracking(RefillTrackingCompanion refill) => into(refillTracking).insert(refill);

  Future<int> updateRefillTracking(RefillTrackingCompanion refill) => (update(refillTracking)
          ..where((t) => t.medicationId.equals(refill.medicationId.value)))
        .write(refill);

  Future<RefillTrackingData?> getRefillTrackingForMedication(int medicationId) => (select(
      refillTracking,
    )..where((t) => t.medicationId.equals(medicationId))).getSingleOrNull();
}

LazyDatabase _openConnection() {
  if (Platform.isAndroid || Platform.isIOS) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'takeyourpills.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'takeyourpills.db'));
    return NativeDatabase(file);
  });
}
