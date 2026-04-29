part of 'medication_list_cubit.dart';

/// Base class for all medication list states.
abstract class MedicationListState extends Equatable {
  const MedicationListState();

  @override
  List<Object> get props => [];
}

/// Initial state before any data is loaded.
class MedicationListInitial extends MedicationListState {}

/// Loading state while fetching medications.
class MedicationListLoading extends MedicationListState {}

/// Successfully loaded medications.
class MedicationListLoaded extends MedicationListState {
  final List<Medication> medications;

  const MedicationListLoaded({required this.medications});

  @override
  List<Object> get props => [medications];
}

/// No medications exist.
class MedicationListEmpty extends MedicationListState {}

/// Error state with a human-readable message.
class MedicationListError extends MedicationListState {
  final String message;

  const MedicationListError({required this.message});

  @override
  List<Object> get props => [message];
}
