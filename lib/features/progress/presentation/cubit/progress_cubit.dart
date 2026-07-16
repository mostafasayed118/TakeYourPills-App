import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/dose_log.dart';
import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/dose_occurrence_utils.dart';
import '../../../../data/repositories/medication_repository.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit({required MedicationRepository repository})
      : _repository = repository,
        super(const ProgressInitial());

  final MedicationRepository _repository;

  static const _weekDays = 7;
  static const _monthDays = 30;

  /// Day abbreviations for the weekly chart.
  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Future<void> loadProgress() async {
    emit(const ProgressLoading());

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // ── Weekly data (last 7 days) ──────────────────────────────────
      final weekStart = today.subtract(const Duration(days: _weekDays - 1));
      final weekEnd = today.add(const Duration(days: 1));

      final meds = (await _repository.getAllMedications()).getOrNull() ??
          const <Medication>[];
      final weekLogs =
          (await _repository.getDoseLogsForDateRange(weekStart, weekEnd))
                  .getOrNull() ??
              const <DoseLog>[];

      final weekOccurrences = occurrencesForRange(
        medications: meds,
        rangeStart: weekStart,
        rangeEnd: weekEnd,
      );

      final dayStats = <DayStat>[];
      final weeklyBars = <BarStat>[];
      var totalTaken = 0;
      var totalScheduled = 0;

      for (var i = 0; i < _weekDays; i++) {
        final day = weekStart.add(Duration(days: i));
        final dayEnd = day.add(const Duration(days: 1));
        final dayOcc = weekOccurrences
            .where(
              (o) =>
                  !o.scheduledTime.isBefore(day) &&
                  o.scheduledTime.isBefore(dayEnd),
            )
            .toList();
        final scheduled = dayOcc.length;
        var taken = 0;
        for (final occ in dayOcc) {
          final matched = weekLogs.any(
            (l) =>
                logMatchesOccurrence(l, occ) &&
                l.status == DoseLogStatus.taken,
          );
          if (matched) taken++;
        }
        totalTaken += taken;
        totalScheduled += scheduled;
        dayStats.add(DayStat(day: day, taken: taken, scheduled: scheduled));

        final pct = scheduled > 0
            ? (taken / scheduled * 100).clamp(0.0, 100.0)
            : 0.0;
        weeklyBars.add(BarStat(
          label: _dayLabels[i],
          adherencePercent: pct,
          taken: taken,
          scheduled: scheduled,
        ));
      }

      // ── Monthly data (last 30 days) ────────────────────────────────
      final monthStart = today.subtract(const Duration(days: _monthDays - 1));
      final monthLogs =
          (await _repository.getDoseLogsForDateRange(monthStart, weekEnd))
                  .getOrNull() ??
              const <DoseLog>[];

      final monthOccurrences = occurrencesForRange(
        medications: meds,
        rangeStart: monthStart,
        rangeEnd: weekEnd,
      );

      final monthlyPoints = <LineStat>[];
      for (var i = 0; i < _monthDays; i++) {
        final day = monthStart.add(Duration(days: i));
        final dayEnd = day.add(const Duration(days: 1));
        final dayOcc = monthOccurrences
            .where(
              (o) =>
                  !o.scheduledTime.isBefore(day) &&
                  o.scheduledTime.isBefore(dayEnd),
            )
            .toList();
        final scheduled = dayOcc.length;
        var taken = 0;
        for (final occ in dayOcc) {
          final matched = monthLogs.any(
            (l) =>
                logMatchesOccurrence(l, occ) &&
                l.status == DoseLogStatus.taken,
          );
          if (matched) taken++;
        }
        final pct = scheduled > 0
            ? (taken / scheduled * 100).clamp(0.0, 100.0)
            : 0.0;
        monthlyPoints.add(LineStat(day: day, adherencePercent: pct));
      }

      emit(ProgressLoaded(
        stats: dayStats,
        totalTaken: totalTaken,
        totalScheduled: totalScheduled,
        weeklyBars: weeklyBars,
        monthlyPoints: monthlyPoints,
      ));
    } on Object catch (e) {
      emit(ProgressError(message: e.toString()));
    }
  }

  void setViewMode(ChartView mode) {
    final current = state;
    if (current is ProgressLoaded) {
      emit(current.copyWith(viewMode: mode));
    }
  }
}
