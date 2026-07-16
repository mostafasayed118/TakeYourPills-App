import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../data/repositories/medication_repository.dart';
import '../../../../shared/services/reminder_scheduler_service.dart';

part 'medication_detail_state.dart';

/// Cubit managing the medication detail screen state.
///
/// Loads a single medication by ID from the repository.
/// Standalone — does not depend on MedicationListCubit.
class MedicationDetailCubit extends Cubit<MedicationDetailState> {

  MedicationDetailCubit({
    required MedicationRepository repository,
    required this.medicationId, ReminderSchedulerService? scheduler,
  }) : _repository = repository,
       _scheduler =
           scheduler ??
           (GetIt.instance.isRegistered<ReminderSchedulerService>()
               ? GetIt.instance<ReminderSchedulerService>()
               : NoOpReminderSchedulerService()),
       super(MedicationDetailLoading()) {
    loadMedication();
  }
  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  final int medicationId;
  bool _isTogglingPause = false;

  Future<void> loadMedication() async {
    try {
      emit(MedicationDetailLoading());
      final result = await _repository.getMedicationById(medicationId);
      result.fold((medication) {
        if (medication != null) {
          emit(MedicationDetailLoaded(medication: medication));
        } else {
          emit(const MedicationDetailError(message: 'Medication not found'));
        }
      }, (error) => emit(MedicationDetailError(message: error.toString())));
    } catch (e) {
      emit(MedicationDetailError(message: e.toString()));
    }
  }

  Future<void> deleteMedication() async {
    try {
      await _scheduler.cancelAllForMedication(medicationId);
      final result = await _repository.deleteMedication(medicationId);
      result.fold(
        (_) => emit(MedicationDetailDeleted()),
        (error) =>
            emit(MedicationDetailError(message: 'Failed to delete: $error')),
      );
    } catch (e) {
      emit(MedicationDetailError(message: 'Failed to delete: ${e.toString()}'));
    }
  }

  Future<void> togglePause() async {
    if (_isTogglingPause) return;

    final currentState = state;
    if (currentState is! MedicationDetailLoaded) return;

    _isTogglingPause = true;
    try {
      final med = currentState.medication;
      final updated = med.copyWith(
        isPaused: !med.isPaused,
        updatedAt: DateTime.now(),
      );
      final result = await _repository.updateMedication(updated);

      if (result.isSuccess) {
        if (updated.isPaused) {
          await _scheduler.cancelAllForMedication(medicationId);
        } else {
          await _scheduler.rescheduleForMedication(updated);
        }

        emit(MedicationDetailLoaded(medication: updated));
      } else {
        emit(const MedicationDetailError(message: 'Failed to update medication'));
      }
    } catch (e) {
      emit(MedicationDetailError(message: e.toString()));
    } finally {
      _isTogglingPause = false;
    }
  }
}
