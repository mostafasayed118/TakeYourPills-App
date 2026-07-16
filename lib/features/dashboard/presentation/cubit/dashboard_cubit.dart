import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/domain/dashboard_domain_service.dart';
import '../../../../core/entities/dose_log.dart';
import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../data/repositories/medication_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required MedicationRepository repository,
    required DashboardDomainService domainService,
  })  : _repository = repository,
        _domainService = domainService,
        super(DashboardInitial()) {
    loadDashboard();
  }

  final MedicationRepository _repository;
  final DashboardDomainService _domainService;
  StreamSubscription<Result<List<Medication>>>? _watchSubscription;

  Future<void> loadDashboard() async {
    try {
      emit(DashboardLoading());
      final medsResult = await _repository.getAllMedications();
      medsResult.fold(
        (medications) => _computeDashboard(medications),
        (error) => emit(DashboardError(message: error.toString())),
      );
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  void watchMedications() {
    _watchSubscription?.cancel();
    _watchSubscription = _repository.watchAllMedications().listen(
      (result) {
        result.fold(
          (medications) => _computeDashboard(medications),
          (error) => emit(DashboardError(message: error.toString())),
        );
      },
      onError: (Object e) {
        emit(DashboardError(message: e.toString()));
      },
    );
  }

  Future<void> _computeDashboard(List<Medication> medications) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day + 1);

    final logsResult = await _repository.getDoseLogsForDateRange(
      todayStart,
      todayEnd,
    );
    final doseLogs = logsResult.getOrNull() ?? const <DoseLog>[];

    final summary = _domainService.computeToday(
      medications: medications,
      todayDoseLogs: doseLogs,
    );

    // Compute streak from last 30 days of logs
    final thirtyDaysAgo = todayStart.subtract(const Duration(days: 29));
    final recentLogsResult = await _repository.getDoseLogsForDateRange(
      thirtyDaysAgo,
      todayEnd,
    );
    final recentLogs = recentLogsResult.getOrNull() ?? const <DoseLog>[];

    final streak = _domainService.computeStreak(
      medications: medications,
      recentLogs: recentLogs,
    );

    emit(
      DashboardLoaded(
        medications: summary.activeMedications,
        takenToday: summary.takenToday,
        totalToday: summary.totalToday,
        adherencePercent: summary.adherencePercent,
        nextDose: summary.nextDose,
        nextDoseTime: summary.nextDoseTime,
        upcomingMedications: summary.upcomingMedications,
        doseOccurrences: summary.doseOccurrences,
        currentStreak: streak.currentStreak,
        bestStreak: streak.bestStreak,
        streakMessage: streak.message,
      ),
    );
  }

  /// Log a dose as taken for the given medication and scheduled time.
  Future<void> takeDose({
    required Medication medication,
    required DateTime scheduledTime,
  }) async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;

    emit(currentState.copyWith(isTakingDose: true));

    try {
      final doseLog = DoseLog(
        id: 0,
        medicationId: medication.id,
        scheduledTime: scheduledTime.toIso8601String(),
        status: DoseLogStatus.taken,
        actualTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _repository.createDoseLog(doseLog);

      result.fold(
        (_) => loadDashboard(), // Refresh to show updated state
        (error) {
          emit(currentState.copyWith(isTakingDose: false));
          emit(DashboardError(message: 'Failed to log dose: $error'));
        },
      );
    } catch (e) {
      emit(currentState.copyWith(isTakingDose: false));
      emit(DashboardError(message: 'Failed to log dose: $e'));
    }
  }

  @override
  Future<void> close() {
    _watchSubscription?.cancel();
    return super.close();
  }
}
