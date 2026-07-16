import '../../data/database/app_database.dart';
import '../../data/database/tables/dose_logs.dart';
import '../../data/database/tables/medications.dart';
import '../../data/database/tables/refill_tracking.dart';
import '../../data/database/tables/schedules.dart';

/// Database service that manages the Drift database instance.
/// This is a singleton service that provides access to the database and DAOs.
class DatabaseService {
  factory DatabaseService() => _instance;

  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();

  late final AppDatabase _db;

  /// Initialize the database service. Must be called once at app startup.
  Future<void> init() async {
    _db = AppDatabase();
  }

  /// Get the AppDatabase instance.
  AppDatabase get db => _db;

  /// Get the medications table DAO.
  Medications get medications => _db.medications;

  /// Get the schedules table DAO.
  Schedules get schedules => _db.schedules;

  /// Get the dose_logs table DAO.
  DoseLogs get doseLogs => _db.doseLogs;

  /// Get the refill_tracking table DAO.
  RefillTracking get refillTracking => _db.refillTracking;

  /// Convenient methods for common operations

  Future<List<MedicationData>> getAllMedications() => _db.getAllMedications();

  Future<MedicationData?> getMedicationById(int id) =>
      _db.getMedicationById(id);

  Future<int> createMedication(MedicationData medication) =>
      _db.into(_db.medications).insert(medication);

  Future<int> updateMedication(MedicationData medication) => (_db.update(
    _db.medications,
  )..where((t) => t.id.equals(medication.id))).write(medication);

  Future<int> deleteMedication(int id) => _db.deleteMedication(id);

  /// Close the database connection.
  Future<void> close() async {
    await _db.close();
  }
}
