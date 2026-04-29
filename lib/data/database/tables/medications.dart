import 'package:drift/drift.dart';

@DataClassName('MedicationData')
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dosageAmount => text()(); // String to handle "1", "1.5", "2 1/2", etc.
  TextColumn get dosageUnit => text()(); // mg, ml, tablet, capsule, etc.
  TextColumn get iconName => text()();
  TextColumn get colorHex => text().withLength(min: 0, max: 7)();
  // Frequency: daily, weekly, as_needed, specific_days
  TextColumn get frequencyType => text()();
  // JSON-encoded list of weekday numbers (0=Mon...6=Sun) for specific_days
  TextColumn get frequencyDays => text().nullable()();
  // Interval for daily frequencies (e.g., "2" = every 2 days)
  IntColumn get frequencyInterval => integer().withDefault(const Constant(1))();
  // JSON-encoded list of times in HH:mm format
  TextColumn get scheduleTimes => text()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get instructions => text().nullable()();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  IntColumn get pillsRemaining => integer().nullable()();
  IntColumn get refillThreshold => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
