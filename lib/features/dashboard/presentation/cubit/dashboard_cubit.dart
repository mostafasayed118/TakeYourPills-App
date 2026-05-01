import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/utils/schedule_parser.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final MedicationRepository _repository;
  StreamSubscription<List<Medication>>? _watchSubscription;

  DashboardCubit(MedicationRepository repository)
    : _repository = repository,
      super(DashboardInitial()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      emit(DashboardLoading());
      final medications = await _repository.getAllMedications();
      await _updateDashboardWithMedications(medications);
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  void watchMedications() {
    _watchSubscription?.cancel();
    _watchSubscription = _repository.watchAllMedications().listen(
      (medications) {
        _updateDashboardWithMedications(medications);
      },
      onError: (Object e) {
        emit(DashboardError(message: e.toString()));
      },
    );
  }

  Future<void> _updateDashboardWithMedications(
    List<Medication> medications,
  ) async {
    final activeMeds = medications.where((m) => !m.isPaused).toList();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day + 1);

    int takenToday = 0;
    int totalToday = 0;
    Medication? nextDose;
    DateTime? nextDoseTime;
    final upcoming = <Medication>[];

    for (final med in activeMeds) {
      final schedules = parseScheduleTimes(med.scheduleTimes);
      totalToday += schedules.length;

      for (final time in schedules) {
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        if (scheduledDateTime.isAfter(now)) {
          if (nextDoseTime == null ||
              scheduledDateTime.isBefore(nextDoseTime)) {
            nextDose = med;
            nextDoseTime = scheduledDateTime;
          }
        }
      }

      if (schedules.any((t) {
        final st = DateTime(
          now.year,
          now.month,
          now.day,
          t.hour,
          t.minute,
        );
        return st.isAfter(now);
      })) {
        upcoming.add(med);
      }
    }

    final doseLogs = await _repository.getDoseLogsForDateRange(
      todayStart,
      todayEnd,
    );
    takenToday = doseLogs
        .where((log) => log.status == DoseLogStatus.taken)
        .length;

    final adherencePercent = totalToday > 0
        ? (takenToday / totalToday * 100).clamp(0.0, 100.0)
        : 0.0;

    upcoming.sort((a, b) {
      final aTimes = parseScheduleTimes(a.scheduleTimes);
      final bTimes = parseScheduleTimes(b.scheduleTimes);
      if (aTimes.isEmpty || bTimes.isEmpty) return 0;
      return aTimes.first.compareTo(bTimes.first);
    });

    emit(
      DashboardLoaded(
        medications: activeMeds,
        takenToday: takenToday,
        totalToday: totalToday,
        adherencePercent: adherencePercent,
        nextDose: nextDose,
        nextDoseTime: nextDoseTime,
        upcomingMedications: upcoming.take(3).toList(),
      ),
    );
  }

  Future<void> close() {
    _watchSubscription?.cancel();
    return super.close();
  }
}
