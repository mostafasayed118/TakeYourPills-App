import 'package:equatable/equatable';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';

abstract class MedicationFormState extends Equatable {
  const MedicationFormState();

  @override
  List<Object> get props => [];
}

class MedicationFormInitial extends MedicationFormState {}

class MedicationFormEditing extends MedicationFormState {
  final String name;
  final String dosageAmount;
  final String dosageUnit;
  final String iconName;
  final String colorHex;
  final String frequencyType;
  final String frequencyDays;
  final int frequencyInterval;
  final String scheduleTimes;
  final String? startDate;
  final String? endDate;
  final String? instructions;
  final bool isPaused;
  final int? pillsRemaining;
  final int? refillThreshold;
  final Medication? medication;
  final String? validationError;
  final bool isSaving;
  final bool isSuccess;

  const MedicationFormEditing({
    this.name = '',
    this.dosageAmount = '',
    this.dosageUnit = 'mg',
    this.iconName = 'pill',
    this.colorHex = '',
    this.frequencyType = 'daily',
    this.frequencyDays = '[]',
    this.frequencyInterval = 1,
    this.scheduleTimes = '[]',
    this.startDate,
    this.endDate,
    this.instructions,
    this.isPaused = false,
    this.pillsRemaining,
    this.refillThreshold,
    this.medication,
    this.validationError,
    this.isSaving = false,
    this.isSuccess = false,
  });

  MedicationFormEditing copyWith({
    String? name,
    String? dosageAmount,
    String? dosageUnit,
    String? iconName,
    String? colorHex,
    String? frequencyType,
    String? frequencyDays,
    int? frequencyInterval,
    String? scheduleTimes,
    String? startDate,
    String? endDate,
    String? instructions,
    bool? isPaused,
    int? pillsRemaining,
    int? refillThreshold,
    Medication? medication,
    String? validationError,
    bool? isSaving,
    bool? isSuccess,
  }) {
    return MedicationFormEditing(
      name: name ?? this.name,
      dosageAmount: dosageAmount ?? this.dosageAmount,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      frequencyInterval: frequencyInterval ?? this.frequencyInterval,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      instructions: instructions ?? this.instructions,
      isPaused: isPaused ?? this.isPaused,
      pillsRemaining: pillsRemaining ?? this.pillsRemaining,
      refillThreshold: refillThreshold ?? this.refillThreshold,
      medication: medication ?? this.medication,
      validationError: validationError,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object> get props => [
        name,
        dosageAmount,
        dosageUnit,
        iconName,
        colorHex,
        frequencyType,
        frequencyDays,
        frequencyInterval,
        scheduleTimes,
        startDate ?? '',
        endDate ?? '',
        instructions ?? '',
        isPaused,
        pillsRemaining ?? 0,
        refillThreshold ?? 0,
        validationError ?? '',
        isSaving,
        isSuccess,
      ];
}

class MedicationFormSuccess extends MedicationFormState {
  final String message;

  const MedicationFormSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class MedicationFormError extends MedicationFormState {
  final String message;

  const MedicationFormError({required this.message});

  @override
  List<Object> get props => [message];
}
