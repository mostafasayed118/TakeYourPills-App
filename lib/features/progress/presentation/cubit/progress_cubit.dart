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

  static const _days = 7;

  Future<void> loadProgress() async {
    emit(const ProgressLoading());

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final rangeStart = today.subtract(const Duration(days: _days - 1));
      final rangeEnd = today.add(const Duration(days: 1));

      final meds = (await _repository.getAllMedications()).getOrNull() ??
          const <Medication>[];
      final logs =
          (await _repository.getDoseLogsForDateRange(rangeStart, rangeEnd))
                  .getOrNull() ??
              const <DoseLog>[];

      final occurrences = occurrencesForRange(
        medications: meds,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      final dayStats = <DayStat>[];
      var totalTaken = 0;
      var totalScheduled = 0;

      for (var i = 0; i < _days; i++) {
        final day = rangeStart.add(Duration(days: i));
        final dayEnd = day.add(const Duration(days: 1));
        final dayOcc = occurrences
            .where(
              (o) =>
                  !o.scheduledTime.isBefore(day) &&
                  o.scheduledTime.isBefore(dayEnd),
            )
            .toList();
        final scheduled = dayOcc.length;
        var taken = 0;
        for (final occ in dayOcc) {
          final matched = logs.any(
            (l) =>
                logMatchesOccurrence(l, occ) &&
                l.status == DoseLogStatus.taken,
          );
          if (matched) taken++;
        }
        totalTaken += taken;
        totalScheduled += scheduled;
        dayStats.add(DayStat(day: day, taken: taken, scheduled: scheduled));
      }

      emit(ProgressLoaded(
        stats: dayStats,
        totalTaken: totalTaken,
        totalScheduled: totalScheduled,
      ));
    } on Object catch (e) {
      emit(ProgressError(message: e.toString()));
    }
  }
}
