part of 'medication_detail_cubit.dart';

/// Base class for medication detail states.
abstract class MedicationDetailState extends Equatable {
  const MedicationDetailState();

  @override
  List<Object> get props => [];
}

/// Loading the medication data.
class MedicationDetailLoading extends MedicationDetailState {}

/// Successfully loaded medication.
class MedicationDetailLoaded extends MedicationDetailState {
  final Medication medication;

  const MedicationDetailLoaded({required this.medication});

  @override
  List<Object> get props => [medication];
}

/// Error loading or operating on medication.
class MedicationDetailError extends MedicationDetailState {
  final String message;

  const MedicationDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Medication was deleted — signal to pop the screen.
class MedicationDetailDeleted extends MedicationDetailState {}
