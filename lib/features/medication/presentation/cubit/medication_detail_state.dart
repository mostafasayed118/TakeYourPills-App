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

  const MedicationDetailLoaded({required this.medication});
  final Medication medication;

  @override
  List<Object> get props => [medication];
}

/// Error loading or operating on medication.
class MedicationDetailError extends MedicationDetailState {

  const MedicationDetailError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

/// Medication was deleted — signal to pop the screen.
class MedicationDetailDeleted extends MedicationDetailState {}
