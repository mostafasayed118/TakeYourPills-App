import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/utils/validators.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'medication_form_state.dart';

/// Cubit managing the Add/Edit Medication form state.
///
/// Handles field updates, validation, and persistence through
/// the medication repository. Shared between create and edit flows.
class MedicationFormCubit extends Cubit<MedicationFormState> {
  final MedicationRepository _repository;
  final bool isEditing;
  final int? existingMedId;

  MedicationFormCubit({
    required MedicationRepository repository,
    this.isEditing = false,
    this.existingMedId,
  }) : _repository = repository,
       super(MedicationFormInitial()) {
    if (isEditing && existingMedId != null) {
      _loadExistingData(existingMedId!);
    } else {
      emit(
        MedicationFormEditing(
          name: '',
          dosageAmount: '',
          dosageUnit: 'mg',
          iconName: 'pill',
          colorHex: '',
          frequencyType: 'daily',
          frequencyDays: '[]',
          frequencyInterval: 1,
          scheduleTimes: '',
          isPaused: false,
        ),
      );
    }
  }

  Future<void> _loadExistingData(int id) async {
    try {
      final med = await _repository.getMedicationById(id);
      if (med != null) {
        String displayTimes = med.scheduleTimes;
        try {
          final List<dynamic> times = jsonDecode(med.scheduleTimes);
          displayTimes = times.join(', ');
        } catch (_) {
          // Already in display format
        }

        emit(
          MedicationFormEditing(
            name: med.name,
            dosageAmount: med.dosageAmount,
            dosageUnit: med.dosageUnit,
            iconName: med.iconName,
            colorHex: med.colorHex,
            frequencyType: med.frequencyType,
            frequencyDays: med.frequencyDays,
            frequencyInterval: med.frequencyInterval,
            scheduleTimes: displayTimes,
            startDate: med.startDate,
            endDate: med.endDate,
            instructions: med.instructions,
            isPaused: med.isPaused,
            pillsRemaining: med.pillsRemaining,
            refillThreshold: med.refillThreshold,
            medication: med,
          ),
        );
      } else {
        emit(const MedicationFormError(message: 'Medication not found'));
      }
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
    emit(current.copyWith(name: value, validationError: null));
  }

  void updateDosageAmount(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(dosageAmount: value, validationError: null));
  }

  void updateDosageUnit(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(dosageUnit: value, validationError: null));
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
    emit(current.copyWith(frequencyType: value, validationError: null));
  }

  void updateFrequencyDays(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(frequencyDays: value, validationError: null));
  }

  void updateFrequencyInterval(int value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(frequencyInterval: value, validationError: null));
  }

  void updateScheduleTimes(String value) {
    final current = _ensureEditing();
    if (current == null) return;
    emit(current.copyWith(scheduleTimes: value, validationError: null));
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

  String _parseScheduleTimesToJson(String input) {
    if (input.isEmpty) return '[]';
    final times = input
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    return jsonEncode(times);
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

    final times = s.scheduleTimes
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final timeRegex = RegExp(r'^([01]?\d|2[0-3]):([0-5]\d)$');
    for (final time in times) {
      if (!timeRegex.hasMatch(time)) {
        return 'Invalid time format: "$time". Use HH:MM (e.g., 08:00)';
      }
    }

    const validFrequencies = ['daily', 'weekly', 'as_needed', 'specific_days'];
    if (!validFrequencies.contains(s.frequencyType)) {
      return 'Invalid frequency type';
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

    emit(current.copyWith(isSaving: true, validationError: null));

    try {
      final scheduleTimesJson = _parseScheduleTimesToJson(
        current.scheduleTimes,
      );

      final medication = Medication(
        id: isEditing && current.medication != null
            ? current.medication!.id
            : 0,
        name: current.name.trim(),
        dosageAmount: current.dosageAmount.trim(),
        dosageUnit: current.dosageUnit.trim(),
        iconName: current.iconName,
        colorHex: current.colorHex,
        frequencyType: current.frequencyType,
        frequencyDays: current.frequencyDays,
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
        await _repository.updateMedication(medication);
        emit(
          const MedicationFormSuccess(
            message: 'Medication updated successfully',
          ),
        );
      } else {
        await _repository.createMedication(medication);
        emit(
          const MedicationFormSuccess(
            message: 'Medication created successfully',
          ),
        );
      }
    } catch (e) {
      emit(
        current.copyWith(
          isSaving: false,
          validationError: 'Failed to save: ${e.toString()}',
          isSuccess: false,
        ),
      );
    }
  }
}
