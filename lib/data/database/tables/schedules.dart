import 'package:drift/drift.dart';

import 'medications.dart';

@DataClassName('ScheduleData')
class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().references(
    Medications,
    #id,
    onDelete: CascadeBehavior.cascade,
  )();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdaysBitfield =>
      integer().withDefault(const Constant(127))();
  BoolColumn get isAsNeeded => boolean().withDefault(const Constant(false))();
}
