part of 'medication_form_cubit.dart';

/// Base class for all medication form states.
abstract class MedicationFormState extends Equatable {
  const MedicationFormState();

  @override
  List<Object?> get props => [];
}

/// Initial state before form is ready.
class MedicationFormInitial extends MedicationFormState {}

/// Active editing state containing all form field values.
class MedicationFormEditing extends MedicationFormState {

  const MedicationFormEditing({
    this.name = '',
    this.dosageAmount = '',
    this.dosageUnit = 'mg',
    this.iconName = 'pill',
    this.colorHex = '',
    this.frequencyType = 'daily',
    this.frequencyDays = '[]',
    this.frequencyInterval = 1,
    this.scheduleTimes = '',
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

  /// The original medication when editing (null when creating)
  final Medication? medication;

  /// Current validation error to display, if any
  final String? validationError;

  /// Whether a save operation is in progress
  final bool isSaving;

  /// Whether the last operation was successful
  final bool isSuccess;

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
  }) => MedicationFormEditing(
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

  @override
  List<Object?> get props => [
    name,
    dosageAmount,
    dosageUnit,
    iconName,
    colorHex,
    frequencyType,
    frequencyDays,
    frequencyInterval,
    scheduleTimes,
    startDate,
    endDate,
    instructions,
    isPaused,
    pillsRemaining,
    refillThreshold,
    medication,
    validationError,
    isSaving,
    isSuccess,
  ];
}

/// Form saved successfully.
class MedicationFormSuccess extends MedicationFormState {

  const MedicationFormSuccess({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

/// Unrecoverable form error.
class MedicationFormError extends MedicationFormState {

  const MedicationFormError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
