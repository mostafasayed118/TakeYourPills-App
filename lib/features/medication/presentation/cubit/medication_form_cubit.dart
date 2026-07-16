import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/repositories/medication_repository.dart';
import '../../../../shared/services/reminder_scheduler_service.dart';

part 'medication_form_state.dart';

/// Cubit managing the Add/Edit Medication form state.
///
/// Handles field updates, validation, and persistence through
/// the medication repository. Shared between create and edit flows.
class MedicationFormCubit extends Cubit<MedicationFormState> {

  MedicationFormCubit({
    required MedicationRepository repository,
    ReminderSchedulerService? scheduler,
    this.isEditing = false,
    this.existingMedId,
  }) : _repository = repository,
       _scheduler =
           scheduler ??
           (GetIt.instance.isRegistered<ReminderSchedulerService>()
               ? GetIt.instance<ReminderSchedulerService>()
               : NoOpReminderSchedulerService()),
       super(MedicationFormInitial()) {
    if (isEditing && existingMedId != null) {
      _loadExistingData(existingMedId!);
    } else {
      emit(
        const MedicationFormEditing(
          
        ),
      );
    }
  }
  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  final bool isEditing;
  final int? existingMedId;

  Future<void> _loadExistingData(int id) async {
    try {
      final result = await _repository.getMedicationById(id);
      result.fold(
        (med) {
          if (med != null) {
            emit(MedicationFormEditing.fromMedication(med));
          } else {
            emit(const MedicationFormError(message: 'Medication not found'));
          }
        },
        (error) => emit(
          MedicationFormError(message: 'Failed to load medication: $error'),
        ),
      );
    } catch (e) {
      emit(
        MedicationFormError(
          message: 'Failed to load medication: ${e.toString()}',
        ),
      );
    }
  }

  // ── Field update methods ─────────────────────────────────────

  void updateName(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(name: value));
  }

  void updateDosageAmount(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(dosageAmount: value));
  }

  void updateDosageUnit(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(dosageUnit: value));
  }

  void updateIconName(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(iconName: value));
  }

  void updateColorHex(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(colorHex: value));
  }

  void updateFrequencyType(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(frequencyType: value));
  }

  void updateFrequencyDays(List<int> value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(frequencyDays: value));
  }

  void updateFrequencyInterval(int value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(frequencyInterval: value));
  }

  void updateScheduleTimes(List<String> value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(scheduleTimes: value));
  }

  void updateStartDate(String? value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(startDate: value));
  }

  void updateEndDate(String? value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(endDate: value));
  }

  void updateInstructions(String? value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(instructions: value));
  }

  void updateIsPaused(bool value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(isPaused: value));
  }

  void updatePillsRemaining(int? value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(pillsRemaining: value));
  }

  void updateRefillThreshold(int? value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(refillThreshold: value));
  }

  // ── Helpers ──────────────────────────────────────────────────

  MedicationFormEditing? _ensureEditing() {
    if (state is MedicationFormEditing) {
      return state as MedicationFormEditing;
    }
    return null;
  }

  String _convertScheduleTimesListToJson(List<String> input) {
    if (input.isEmpty) return '[]';
    return jsonEncode(input);
  }

  String _convertFrequencyDaysListToJson(List<int> input) {
    if (input.isEmpty) return '[]';
    return jsonEncode(input);
  }

  String? _validateForm(MedicationFormEditing s) {
    final nameError = Validators.medicationName(s.name);
    if (nameError != null) return nameError;

    if (s.dosageAmount.isEmpty) return 'Dosage amount is required';
    final dosageNum = double.tryParse(s.dosageAmount);
    if (dosageNum == null) return 'Dosage must be a number';
    final dosageError = Validators.dosage(dosageNum);
    if (dosageError != null) return dosageError;

    if (s.dosageUnit.isEmpty) return 'Dosage unit is required';

    if (s.scheduleTimes.isEmpty) {
      return 'At least one schedule time is required (e.g., 08:00)';
    }

    final timeRegex = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$');
    for (final time in s.scheduleTimes) {
      if (!timeRegex.hasMatch(time)) {
        return 'Invalid time format: "$time". Use HH:MM (e.g., 08:00)';
      }
    }

    const validFrequencies = ['daily', 'weekly', 'as_needed', 'specific_days'];
    if (!validFrequencies.contains(s.frequencyType)) {
      return 'Invalid frequency type';
    }

    if (s.frequencyType == 'specific_days' && s.frequencyDays.isEmpty) {
      return 'Select at least one day for specific days frequency';
    }

    return null;
  }

  // ── Save ─────────────────────────────────────────────────────

  Future<void> saveMedication() async {
    final current = _ensureEditing();
    if (current == null) return;

    final error = _validateForm(current);
    if (error != null) {
      emit(current.copyWith(validationError: error, isSaving: false));
      return;
    }

    emit(current.copyWith(isSaving: true));

    final scheduleTimesJson = _convertScheduleTimesListToJson(current.scheduleTimes);
    final frequencyDaysJson = _convertFrequencyDaysListToJson(current.frequencyDays);

    final medication = Medication(
      id: isEditing && current.medication != null ? current.medication!.id : 0,
      name: current.name.trim(),
      dosageAmount: current.dosageAmount.trim(),
      dosageUnit: current.dosageUnit.trim(),
      iconName: current.iconName,
      colorHex: current.colorHex,
      frequencyType: current.frequencyType,
      frequencyDays: frequencyDaysJson,
      frequencyInterval: current.frequencyInterval,
      scheduleTimes: scheduleTimesJson,
      startDate: current.startDate,
      endDate: current.endDate,
      instructions: current.instructions?.trim(),
      isPaused: current.isPaused,
      pillsRemaining: current.pillsRemaining,
      refillThreshold: current.refillThreshold,
      createdAt: isEditing && current.medication != null
          ? current.medication!.createdAt
          : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEditing && current.medication != null) {
      final result = await _repository.updateMedication(medication);
      result.fold(
        (id) async {
          await _scheduler.rescheduleForMedication(medication);
          emit(
            const MedicationFormSuccess(
              message: 'Medication updated successfully',
            ),
          );
        },
        (error) => emit(
          current.copyWith(
            isSaving: false,
            validationError: 'Failed to update: $error',
            isSuccess: false,
          ),
        ),
      );
    } else {
      final result = await _repository.createMedication(medication);
      result.fold(
        (id) async {
          await _scheduler.scheduleForMedication(medication);
          emit(
            const MedicationFormSuccess(
              message: 'Medication created successfully',
            ),
          );
        },
        (error) => emit(
          current.copyWith(
            isSaving: false,
            validationError: 'Failed to create: $error',
            isSuccess: false,
          ),
        ),
      );
    }
  }
}
