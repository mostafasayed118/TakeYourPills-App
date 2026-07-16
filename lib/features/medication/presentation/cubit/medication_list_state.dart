part of 'medication_list_cubit.dart';

/// Filter for medication list.
enum MedicationFilter { all, active, paused }

/// Sort option for medication list.
enum MedicationSort { name, nextDose, recentlyAdded }

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
  const MedicationListLoaded({
    required this.medications,
    required this.filteredMedications,
    this.searchQuery = '',
    this.filter = MedicationFilter.all,
    this.sort = MedicationSort.recentlyAdded,
  });

  final List<Medication> medications;
  final List<Medication> filteredMedications;
  final String searchQuery;
  final MedicationFilter filter;
  final MedicationSort sort;

  MedicationListLoaded copyWith({
    List<Medication>? medications,
    List<Medication>? filteredMedications,
    String? searchQuery,
    MedicationFilter? filter,
    MedicationSort? sort,
  }) =>
      MedicationListLoaded(
        medications: medications ?? this.medications,
        filteredMedications: filteredMedications ?? this.filteredMedications,
        searchQuery: searchQuery ?? this.searchQuery,
        filter: filter ?? this.filter,
        sort: sort ?? this.sort,
      );

  @override
  List<Object> get props => [
        medications,
        filteredMedications,
        searchQuery,
        filter,
        sort,
      ];
}

/// No medications exist.
class MedicationListEmpty extends MedicationListState {}

/// Error state with a human-readable message.
class MedicationListError extends MedicationListState {
  const MedicationListError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
