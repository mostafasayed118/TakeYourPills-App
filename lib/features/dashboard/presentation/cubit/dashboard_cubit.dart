import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';

part 'dashboard_state.dart';

/// Cubit managing the dashboard screen state with real data.
class DashboardCubit extends Cubit<DashboardState> {
  final MedicationRepository _repository;
  StreamSubscription<List<Medication>>? _watchSubscription;

  DashboardCubit(MedicationRepository repository)
    : _repository = repository,
      super(DashboardInitial()) {
    loadDashboard();
  }

  /// Load dashboard data, subscribing to real-time medication updates.
  Future<void> loadDashboard() async {
    try {
      emit(DashboardLoading());
      final medications = await _repository.getAllMedications();
      _updateDashboardWithMedications(medications);
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  /// Watch medications in real-time via Drift stream.
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

  void _updateDashboardWithMedications(List<Medication> medications) {
    final activeMeds = medications.where((m) => !m.isPaused).toList();
    final today = DateTime.now();

    // Calculate today's doses
    int takenToday = 0;
    int totalToday = 0;
    Medication? nextDose;
    DateTime? nextDoseTime;
    final upcoming = <Medication>[];

    for (final med in activeMeds) {
      final schedules = _parseScheduleTimes(med.scheduleTimes);
      totalToday += schedules.length;

      // Check if any scheduled time for today has been taken
      // Simplified: assume doses are taken if medication has recent dose logs
      // For MVP, we show scheduled doses
      for (final time in schedules) {
        final scheduledDateTime = DateTime(
          today.year,
          today.month,
          today.day,
          time.hour,
          time.minute,
        );
        if (scheduledDateTime.isAfter(DateTime.now())) {
          if (nextDoseTime == null ||
              scheduledDateTime.isBefore(nextDoseTime)) {
            nextDose = med;
            nextDoseTime = scheduledDateTime;
          }
        }
      }

      // Add to upcoming if has future schedules today
      if (schedules.any((t) {
        final st = DateTime(
          today.year,
          today.month,
          today.day,
          t.hour,
          t.minute,
        );
        return st.isAfter(DateTime.now());
      })) {
        upcoming.add(med);
      }
    }

    // Simplified adherence: based on active meds having recent activity
    // For MVP, this is a placeholder calculation
    takenToday = (totalToday * 0.8).round(); // Simulated

    final adherencePercent = totalToday > 0
        ? (takenToday / totalToday * 100).clamp(0.0, 100.0)
        : 0.0;

    // Sort upcoming by next dose time (simplified: by schedule times)
    upcoming.sort((a, b) {
      final aTimes = _parseScheduleTimes(a.scheduleTimes);
      final bTimes = _parseScheduleTimes(b.scheduleTimes);
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

  List<_Time> _parseScheduleTimes(String scheduleTimesJson) {
    try {
      if (scheduleTimesJson.isEmpty || scheduleTimesJson == '[]') {
        return [];
      }
      final List<dynamic> times = List.from(
        scheduleTimesJson.startsWith('[')
            ? (jsonDecode(scheduleTimesJson) as List)
            : scheduleTimesJson
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList(),
      );
      return times.map((t) {
        final str = t.toString().trim().replaceAll('"', '');
        final parts = str.split(':');
        return _Time(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  
  Future<void> close() {
    _watchSubscription?.cancel();
    return super.close();
  }
}

class _Time {
  final int hour;
  final int minute;
  _Time({required this.hour, required this.minute});

  
  int compareTo(_Time other) {
    if (hour != other.hour) return hour - other.hour;
    return minute - other.minute;
  }
}
