import 'package:drift/drift.dart';
import 'medications.dart';
import 'schedules.dart';

class DoseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().customConstraint('NOT NULL REFERENCES medications(id)')();
  IntColumn? get scheduleId => integer().nullable().customConstraint('REFERENCES schedules(id)')();
  TextColumn get scheduledTime => text()();
  DateTimeColumn? get actualTime => dateTime().nullable()();
  IntColumn get status => integer()();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  TextColumn? get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
