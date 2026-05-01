import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

part 'medication_list_state.dart';

/// Cubit managing the medication list screen state.
///
/// Loads all medications from the repository and provides
/// operations for pause/resume and delete.
class MedicationListCubit extends Cubit<MedicationListState> {
  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  StreamSubscription<List<Medication>>? _watchSubscription;

  MedicationListCubit(
    MedicationRepository repository, {
    ReminderSchedulerService? scheduler,
  })  : _repository = repository,
       _scheduler = scheduler ??
           (GetIt.instance.isRegistered<ReminderSchedulerService>()
               ? GetIt.instance<ReminderSchedulerService>()
               : NoOpReminderSchedulerService()),
       super(MedicationListInitial());

  /// Load all medications from the repository.
  Future<void> loadMedications() async {
    try {
      emit(MedicationListLoading());
      final medications = await _repository.getAllMedications();
      if (medications.isEmpty) {
        emit(MedicationListEmpty());
      } else {
        emit(MedicationListLoaded(medications: medications));
      }
    } catch (e) {
      emit(MedicationListError(message: e.toString()));
    }
  }

  /// Subscribe to real-time medication updates via Drift stream.
  void watchMedications() {
    _watchSubscription?.cancel();
    _watchSubscription = _repository.watchAllMedications().listen(
      (medications) {
        if (medications.isEmpty) {
          emit(MedicationListEmpty());
        } else {
          emit(MedicationListLoaded(medications: medications));
        }
      },
      onError: (Object e) {
        emit(MedicationListError(message: e.toString()));
      },
    );
  }

  /// Refresh the medication list.
  Future<void> refresh() async {
    await loadMedications();
  }

  /// Delete a medication by ID.
  Future<void> deleteMedication(int id) async {
    try {
      final currentState = state;
      await _scheduler.cancelAllForMedication(id);
      await _repository.deleteMedication(id);

      if (currentState is MedicationListLoaded) {
        final updated =
            currentState.medications.where((m) => m.id != id).toList();
        if (updated.isEmpty) {
          emit(MedicationListEmpty());
        } else {
          emit(MedicationListLoaded(medications: updated));
        }
      }
    } catch (e) {
      emit(MedicationListError(
        message: 'Failed to delete medication: ${e.toString()}',
      ));
    }
  }

  /// Toggle the paused state of a medication.
  Future<void> pauseMedication(int id, bool isPaused) async {
    try {
      final currentState = state;
      if (currentState is MedicationListLoaded) {
        final med = currentState.medications.firstWhere((m) => m.id == id);
        final updated = med.copyWith(
          isPaused: isPaused,
          updatedAt: DateTime.now(),
        );
        await _repository.updateMedication(updated);

        if (isPaused) {
          await _scheduler.cancelAllForMedication(id);
        } else {
          await _scheduler.rescheduleForMedication(updated);
        }

        final newList =
            currentState.medications.map((m) => m.id == id ? updated : m).toList();
        emit(MedicationListLoaded(medications: newList));
      }
    } catch (e) {
      // Revert on error by reloading
      await loadMedications();
    }
  }

  @override
  Future<void> close() {
    _watchSubscription?.cancel();
    return super.close();
  }
}
