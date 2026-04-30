import 'package:drift/drift.dart';

import 'schedules.dart';
import 'medications.dart';

@DataClassName('DoseLogData')
class DoseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  IntColumn? get scheduleId => integer().nullable().references(
    Schedules,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get scheduledTime => text()();
  DateTimeColumn? get actualTime => dateTime().nullable()();
  IntColumn get status => integer()();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  TextColumn? get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
