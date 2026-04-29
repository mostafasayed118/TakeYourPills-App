import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/utils/validators.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';

part 'medication_form_state.dart';

class MedicationFormCubit extends Cubit<MedicationFormState> {
  final MedicationRepositoryImpl _repository;
  final bool isEditing;
  final String? existingMedId;

  MedicationFormCubit({
    required MedicationRepositoryImpl repository,
    this.isEditing = false,
    this.existingMedId,
  }) : super(MedicationFormInitial()) {
    if (isEditing && existingMedId != null) {
      _loadExistingData(int.parse(existingMedId!));
    } else {
      emit(MedicationFormEditing(
        name: '',
        dosageAmount: '',
        dosageUnit: 'mg',
        iconName: 'pill',
        colorHex: '',
        frequencyType: 'daily',
        frequencyDays: '[]',
        frequencyInterval: 1,
        scheduleTimes: '[]',
        isPaused: false,
      ));
    }
  }

  Future<void> _loadExistingData(int id) async {
    try {
      final med = await _repository.getMedicationById(id);
      if (med != null) {
        emit(MedicationFormEditing(
          name: med.name,
          dosageAmount: med.dosageAmount,
          dosageUnit: med.dosageUnit,
          iconName: med.iconName,
          colorHex: med.colorHex,
          frequencyType: med.frequencyType,
          frequencyDays: med.frequencyDays,
          frequencyInterval: med.frequencyInterval,
          scheduleTimes: med.scheduleTimes,
          startDate: med.startDate,
          endDate: med.endDate,
          instructions: med.instructions,
          isPaused: med.isPaused,
          pillsRemaining: med.pillsRemaining,
          refillThreshold: med.refillThreshold,
          medication: med,
        ));
      }
    } catch (e) {
      emit(MedicationFormError(message: 'Failed to load medication: ${e.toString()}'));
    }
  }

  void updateName(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(name: value, validationError: null));
  }

  void updateDosageAmount(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(dosageAmount: value, validationError: null));
  }

  void updateDosageUnit(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(dosageUnit: value, validationError: null));
  }

  void updateIconName(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(iconName: value));
  }

  void updateColorHex(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(colorHex: value));
  }

  void updateFrequencyType(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(frequencyType: value, validationError: null));
  }

  void updateFrequencyDays(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(frequencyDays: value, validationError: null));
  }

  void updateFrequencyInterval(int value) {
    final current = _getCurrentState();
    emit(current.copyWith(frequencyInterval: value, validationError: null));
  }

  void updateScheduleTimes(String value) {
    final current = _getCurrentState();
    emit(current.copyWith(scheduleTimes: value, validationError: null));
  }

  void updateStartDate(String? value) {
    final current = _getCurrentState();
    emit(current.copyWith(startDate: value));
  }

  void updateEndDate(String? value) {
    final current = _getCurrentState();
    emit(current.copyWith(endDate: value));
  }

  void updateInstructions(String? value) {
    final current = _getCurrentState();
    emit(current.copyWith(instructions: value));
  }

  void updateIsPaused(bool value) {
    final current = _getCurrentState();
    emit(current.copyWith(isPaused: value));
  }

  void updatePillsRemaining(int? value) {
    final current = _getCurrentState();
    emit(current.copyWith(pillsRemaining: value));
  }

  void updateRefillThreshold(int? value) {
    final current = _getCurrentState();
    emit(current.copyWith(refillThreshold: value));
  }

  MedicationFormState _getCurrentState() {
    if (state is MedicationFormEditing) {
      return state as MedicationFormEditing;
    }
    return MedicationFormEditing(
      name: '',
      dosageAmount: '',
      dosageUnit: 'mg',
      iconName: 'pill',
      colorHex: '',
      frequencyType: 'daily',
      frequencyDays: '[]',
      frequencyInterval: 1,
      scheduleTimes: '[]',
      isPaused: false,
    );
  }

  String? _validateForm(MedicationFormEditing s) {
    final nameError = Validators.medicationName(s.name);
    if (nameError != null) return nameError;

    if (s.dosageAmount.isEmpty) return 'Dosage amount is required';
    final dosageError = Validators.dosage(double.tryParse(s.dosageAmount) ?? 0);
    if (dosageError != null) return dosageError;

    if (s.dosageUnit.isEmpty) return 'Dosage unit is required';

    if (s.scheduleTimes.isEmpty || s.scheduleTimes == '[]') {
      return 'At least one schedule time is required';
    }

    return null;
  }

  Future<void> saveMedication() async {
    final current = _getCurrentState();
    if (current is! MedicationFormEditing) return;

    final error = _validateForm(current);
    if (error != null) {
      emit(current.copyWith(validationError: error, isSaving: false));
      return;
    }

    emit(current.copyWith(isSaving: true, validationError: null));

    try {
      final medication = Medication(
        id: isEditing && current.medication != null ? current.medication!.id : 0,
        name: current.name,
        dosageAmount: current.dosageAmount,
        dosageUnit: current.dosageUnit,
        iconName: current.iconName,
        colorHex: current.colorHex,
        frequencyType: current.frequencyType,
        frequencyDays: current.frequencyDays,
        frequencyInterval: current.frequencyInterval,
        scheduleTimes: current.scheduleTimes,
        startDate: current.startDate,
        endDate: current.endDate,
        instructions: current.instructions,
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
        emit(MedicationFormSuccess(message: 'Medication updated successfully'));
      } else {
        await _repository.createMedication(medication);
        emit(MedicationFormSuccess(message: 'Medication created successfully'));
      }
    } catch (e) {
      emit(current.copyWith(
        isSaving: false,
        validationError: 'Failed to save: ${e.toString()}',
        isSuccess: false,
      ));
    }
  }
}
