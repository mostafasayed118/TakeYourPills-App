import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

part 'medication_detail_state.dart';

/// Cubit managing the medication detail screen state.
///
/// Loads a single medication by ID from the repository.
/// Standalone — does not depend on MedicationListCubit.
class MedicationDetailCubit extends Cubit<MedicationDetailState> {
  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  final int medicationId;

  MedicationDetailCubit({
    required MedicationRepository repository,
    ReminderSchedulerService? scheduler,
    required this.medicationId,
  }) : _repository = repository,
       _scheduler =
           scheduler ??
           (GetIt.instance.isRegistered<ReminderSchedulerService>()
               ? GetIt.instance<ReminderSchedulerService>()
               : NoOpReminderSchedulerService()),
       super(MedicationDetailLoading()) {
    loadMedication();
  }

  Future<void> loadMedication() async {
    try {
      emit(MedicationDetailLoading());
      final medication = await _repository.getMedicationById(medicationId);
      if (medication != null) {
        emit(MedicationDetailLoaded(medication: medication));
      } else {
        emit(const MedicationDetailError(message: 'Medication not found'));
      }
    } catch (e) {
      emit(MedicationDetailError(message: e.toString()));
    }
  }

  Future<void> deleteMedication() async {
    try {
      await _repository.deleteMedication(medicationId);
      await _scheduler.cancelAllForMedication(medicationId);
      emit(MedicationDetailDeleted());
    } catch (e) {
      emit(MedicationDetailError(message: 'Failed to delete: ${e.toString()}'));
    }
  }

  Future<void> togglePause() async {
    final currentState = state;
    if (currentState is! MedicationDetailLoaded) return;

    try {
      final med = currentState.medication;
      final updated = med.copyWith(
        isPaused: !med.isPaused,
        updatedAt: DateTime.now(),
      );
      await _repository.updateMedication(updated);

      if (updated.isPaused) {
        await _scheduler.cancelAllForMedication(medicationId);
      } else {
        await _scheduler.rescheduleForMedication(updated);
      }

      emit(MedicationDetailLoaded(medication: updated));
    } catch (e) {
      emit(MedicationDetailError(message: e.toString()));
    }
  }
}
