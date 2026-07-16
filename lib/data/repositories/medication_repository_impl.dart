import '../../core/entities/medication.dart';
import '../../core/error/result.dart';
import '../datasources/medication_local_datasource.dart';
import 'medication_read_repository.dart';
import 'medication_repository.dart';
import 'medication_write_repository.dart';

/// Mixin providing write operations for repository implementations.
mixin MedicationWriteRepositoryMixin on MedicationReadRepository
    implements MedicationWriteRepository {
  MedicationLocalDatasource get localDatasource;

  @override
  Future<Result<int>> createMedication(Medication medication) async {
    try {
      final result = await localDatasource.createMedication(medication);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> updateMedication(Medication medication) async {
    try {
      final result = await localDatasource.updateMedication(medication);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> deleteMedication(int id) async {
    try {
      final result = await localDatasource.deleteMedication(id);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<void>> bulkInsertMedications(
    List<Medication> medications,
  ) async {
    try {
      await localDatasource.bulkInsertMedications(medications);
      return const Success<void>(null);
    } catch (e) {
      return ResultFailure<void>(e.toString());
    }
  }

  @override
  Future<Result<int>> createSchedule(Schedule schedule) async {
    try {
      final result = await localDatasource.createSchedule(schedule);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> updateSchedule(Schedule schedule) async {
    try {
      final result = await localDatasource.updateSchedule(schedule);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> deleteSchedule(int id) async {
    try {
      final result = await localDatasource.deleteSchedule(id);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> deleteSchedulesForMedication(int medicationId) async {
    try {
      final result = await localDatasource.deleteSchedulesForMedication(
        medicationId,
      );
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> createDoseLog(DoseLog doseLog) async {
    try {
      final result = await localDatasource.createDoseLog(doseLog);
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> createOrUpdateRefillTracking({
    required int medicationId,
    required int currentQuantity,
    required int refillThreshold,
    DateTime? lastRefillDate,
    String? notes,
  }) async {
    try {
      final result = await localDatasource.createOrUpdateRefillTracking(
        medicationId: medicationId,
        currentQuantity: currentQuantity,
        refillThreshold: refillThreshold,
        lastRefillDate: lastRefillDate,
        notes: notes,
      );
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }

  @override
  Future<Result<int>> updateCurrentQuantity(
    int medicationId,
    int newQuantity,
  ) async {
    try {
      final result = await localDatasource.updateCurrentQuantity(
        medicationId,
        newQuantity,
      );
      return Success(result);
    } catch (e) {
      return ResultFailure(e.toString());
    }
  }
}

/// Concrete implementation of repository interfaces using local datasource.
class MedicationRepositoryImpl extends MedicationReadRepository
    with MedicationWriteRepositoryMixin
    implements MedicationRepository {

  MedicationRepositoryImpl(this.localDatasource);
  @override
  final MedicationLocalDatasource localDatasource;

  // ── Read Operations ─────────────────────────────────────────────

  @override
  Future<Result<List<Medication>>> getAllMedications() async {
    try {
      final result = await localDatasource.getAllMedications();
      return Success<List<Medication>>(result);
    } catch (e) {
      return ResultFailure<List<Medication>>(e.toString());
    }
  }

  @override
  Future<Result<Medication?>> getMedicationById(int id) async {
    try {
      final result = await localDatasource.getMedicationById(id);
      return Success<Medication?>(result);
    } catch (e) {
      return ResultFailure<Medication?>(e.toString());
    }
  }

  @override
  Future<Result<List<Medication>>> getActiveMedications() async {
    try {
      final result = await localDatasource.getActiveMedications();
      return Success<List<Medication>>(result);
    } catch (e) {
      return ResultFailure<List<Medication>>(e.toString());
    }
  }

  @override
  Stream<Result<List<Medication>>> watchAllMedications() => localDatasource.watchAllMedications().map(
      Success<List<Medication>>.new,
    );

  @override
  Future<Result<List<Schedule>>> getSchedulesForMedication(
    int medicationId,
  ) async {
    try {
      final result = await localDatasource.getSchedulesForMedication(
        medicationId,
      );
      return Success<List<Schedule>>(result);
    } catch (e) {
      return ResultFailure<List<Schedule>>(e.toString());
    }
  }

  @override
  Future<Result<List<DoseLog>>> getDoseLogsForMedication(
    int medicationId,
  ) async {
    try {
      final result = await localDatasource.getDoseLogsForMedication(
        medicationId,
      );
      return Success<List<DoseLog>>(result);
    } catch (e) {
      return ResultFailure<List<DoseLog>>(e.toString());
    }
  }

  @override
  Future<Result<List<DoseLog>>> getDoseLogsForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final result = await localDatasource.getDoseLogsForDateRange(start, end);
      return Success<List<DoseLog>>(result);
    } catch (e) {
      return ResultFailure<List<DoseLog>>(e.toString());
    }
  }

  @override
  Future<Result<({int quantity, int threshold})?>> getRefillInfo(
    int medicationId,
  ) async {
    try {
      final result = await localDatasource.getRefillInfo(medicationId);
      return Success<({int quantity, int threshold})?>(result);
    } catch (e) {
      return ResultFailure<({int quantity, int threshold})?>(e.toString());
    }
  }
}
