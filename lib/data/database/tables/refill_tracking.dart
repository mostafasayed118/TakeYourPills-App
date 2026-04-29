import 'package:drift/drift.dart';
import 'medications.dart';

class RefillTracking extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicationId => integer().customConstraint('NOT NULL UNIQUE REFERENCES medications(id) ON DELETE CASCADE')();
  IntColumn get currentQuantity => integer()();
  IntColumn get refillThreshold => integer()();
  DateTimeColumn? get lastRefillDate => dateTime().nullable()();
  TextColumn? get notes => text().nullable()();
}
