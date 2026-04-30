import 'package:drift/drift.dart';

import 'medications.dart';

@DataClassName('RefillTrackingData')
class RefillTracking extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentQuantity => integer()();
  IntColumn get refillThreshold => integer()();
  DateTimeColumn? get lastRefillDate => dateTime().nullable()();
  TextColumn? get notes => text().nullable()();
}
