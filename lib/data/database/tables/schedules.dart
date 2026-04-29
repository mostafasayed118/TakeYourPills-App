import 'package:drift/drift.dart';
import 'medications.dart';

class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().customConstraint('NOT NULL REFERENCES medications(id) ON DELETE CASCADE')();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdaysBitfield => integer().withDefault(const Constant(127))();
  BoolColumn get isAsNeeded => boolean().withDefault(const Constant(false))();
}
