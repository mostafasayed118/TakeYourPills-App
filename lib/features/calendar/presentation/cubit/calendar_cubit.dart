import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/dose_log.dart';
import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/dose_occurrence_utils.dart';
import '../../../../data/repositories/medication_repository.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required MedicationRepository repository})
      : _repository = repository,
        super(const CalendarInitial());

  final MedicationRepository _repository;

  DateTime _weekStart = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  DateTime get weekStart => _weekStart;
  DateTime get selectedDay => _selectedDay;

  Future<void> loadWeek() async {
    emit(CalendarLoading(
      weekStart: _weekStart,
      selectedDay: _selectedDay,
    ));

    try {
      final rangeStart = _weekStart;
      final rangeEnd = _weekStart.add(const Duration(days: 7));

      final medsResult = await _repository.getAllMedications();
      final logsResult = await _repository.getDoseLogsForDateRange(
        rangeStart,
        rangeEnd,
      );

      final meds = medsResult.getOrNull() ?? const <Medication>[];
      final logs = logsResult.getOrNull() ?? const <DoseLog>[];

      if (medsResult.isFailure) {
        emit(CalendarError(
          message: 'Could not load medications',
          weekStart: _weekStart,
          selectedDay: _selectedDay,
        ));
        return;
      }

      emit(CalendarLoaded(
        weekStart: _weekStart,
        selectedDay: _selectedDay,
        medications: meds,
        doseLogs: logs,
      ));
    } on Object catch (e) {
      emit(CalendarError(
        message: e.toString(),
        weekStart: _weekStart,
        selectedDay: _selectedDay,
      ));
    }
  }

  void selectDay(DateTime day) {
    _selectedDay = day;
    final current = state;
    if (current is CalendarLoaded) {
      emit(current.copyWith(selectedDay: _selectedDay));
    } else if (current is CalendarLoading) {
      emit(current.copyWith(selectedDay: _selectedDay));
    } else if (current is CalendarError) {
      emit(current.copyWith(selectedDay: _selectedDay));
    }
  }

  void shiftWeek(int delta) {
    _weekStart = _weekStart.add(Duration(days: 7 * delta));
    _selectedDay = _weekStart;
    loadWeek();
  }

  List<DoseOccurrence> occurrencesForDay(DateTime day) {
    final meds = _currentMedications();
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return occurrencesForRange(
      medications: meds,
      rangeStart: start,
      rangeEnd: end,
    );
  }

  DoseLogStatus? statusFor(DoseOccurrence occ) {
    final logs = _currentDoseLogs();
    for (final log in logs) {
      if (logMatchesOccurrence(log, occ)) return log.status;
    }
    final now = DateTime.now();
    if (occ.scheduledTime.isBefore(now)) return DoseLogStatus.missed;
    return DoseLogStatus.pending;
  }

  List<Medication> _currentMedications() {
    final current = state;
    if (current is CalendarLoaded) return current.medications;
    return const [];
  }

  List<DoseLog> _currentDoseLogs() {
    final current = state;
    if (current is CalendarLoaded) return current.doseLogs;
    return const [];
  }
}
