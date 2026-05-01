import 'package:takeyourpills_healthcare_app/data/database/app_database.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/medications.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/schedules.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/dose_logs.dart';
import 'package:takeyourpills_healthcare_app/data/database/tables/refill_tracking.dart';

/// Database service that manages the Drift database instance.
/// This is a singleton service that provides access to the database and DAOs.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

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

  Future<List<MedicationData>> getAllMedications() {
    return _db.getAllMedications();
  }

  Future<MedicationData?> getMedicationById(int id) {
    return _db.getMedicationById(id);
  }

  Future<int> createMedication(MedicationData medication) {
    return _db.createMedication(medication);
  }

  Future<int> updateMedication(MedicationData medication) {
    return _db.updateMedicationRow(medication);
  }

  Future<int> deleteMedication(int id) {
    return _db.deleteMedication(id);
  }

  /// Close the database connection.
  Future<void> close() async {
    await _db.close();
  }
}
