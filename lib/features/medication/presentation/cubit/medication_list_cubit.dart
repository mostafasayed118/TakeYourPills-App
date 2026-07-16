import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/medication.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/schedule_parser.dart';
import '../../../../data/repositories/medication_repository.dart';
import '../../../../shared/services/reminder_scheduler_service.dart';

part 'medication_list_state.dart';

/// Cubit managing the medication list screen state.
///
/// Loads all medications from the repository and provides
/// operations for search, filter, sort, pause/resume, and delete.
class MedicationListCubit extends Cubit<MedicationListState> {
  MedicationListCubit(
    MedicationRepository repository, {
    required ReminderSchedulerService scheduler,
  })  : _repository = repository,
        _scheduler = scheduler,
        super(MedicationListInitial());

  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  StreamSubscription<Result<List<Medication>>>? _watchSubscription;

  String _searchQuery = '';
  MedicationFilter _filter = MedicationFilter.all;
  MedicationSort _sort = MedicationSort.recentlyAdded;

  /// Load all medications from the repository.
  Future<void> loadMedications() async {
    try {
      emit(MedicationListLoading());
      final result = await _repository.getAllMedications();
      result.fold(
        (medications) {
          if (medications.isEmpty) {
            emit(MedicationListEmpty());
          } else {
            final filtered = _applyFilters(medications);
            emit(MedicationListLoaded(
              medications: medications,
              filteredMedications: filtered,
              searchQuery: _searchQuery,
              filter: _filter,
              sort: _sort,
            ));
          }
        },
        (error) => emit(MedicationListError(message: error.toString())),
      );
    } catch (e) {
      emit(MedicationListError(message: e.toString()));
    }
  }

  /// Subscribe to real-time medication updates via Drift stream.
  void watchMedications() {
    _watchSubscription?.cancel();
    _watchSubscription = _repository.watchAllMedications().listen(
      (result) {
        result.fold(
          (medications) {
            if (medications.isEmpty) {
              emit(MedicationListEmpty());
            } else {
              final filtered = _applyFilters(medications);
              emit(MedicationListLoaded(
                medications: medications,
                filteredMedications: filtered,
                searchQuery: _searchQuery,
                filter: _filter,
                sort: _sort,
              ));
            }
          },
          (error) => emit(MedicationListError(message: error.toString())),
        );
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

  /// Update search query and re-filter.
  void updateSearch(String query) {
    _searchQuery = query;
    final current = state;
    if (current is MedicationListLoaded) {
      final filtered = _applyFilters(current.medications);
      emit(current.copyWith(
        filteredMedications: filtered,
        searchQuery: query,
      ));
    }
  }

  /// Update filter and re-filter.
  void updateFilter(MedicationFilter filter) {
    _filter = filter;
    final current = state;
    if (current is MedicationListLoaded) {
      final filtered = _applyFilters(current.medications);
      emit(current.copyWith(
        filteredMedications: filtered,
        filter: filter,
      ));
    }
  }

  /// Update sort and re-sort.
  void updateSort(MedicationSort sort) {
    _sort = sort;
    final current = state;
    if (current is MedicationListLoaded) {
      final filtered = _applyFilters(current.medications);
      emit(current.copyWith(
        filteredMedications: filtered,
        sort: sort,
      ));
    }
  }

  /// Delete a medication by ID.
  Future<void> deleteMedication(int id) async {
    try {
      final currentState = state;
      await _scheduler.cancelAllForMedication(id);
      final result = await _repository.deleteMedication(id);

      result.fold(
        (rows) {
          if (currentState is MedicationListLoaded) {
            final updated =
                currentState.medications.where((m) => m.id != id).toList();
            if (updated.isEmpty) {
              emit(MedicationListEmpty());
            } else {
              final filtered = _applyFilters(updated);
              emit(currentState.copyWith(
                medications: updated,
                filteredMedications: filtered,
              ));
            }
          }
        },
        (error) => emit(
          MedicationListError(message: 'Failed to delete medication: $error'),
        ),
      );
    } catch (e) {
      emit(
        MedicationListError(
          message: 'Failed to delete medication: ${e.toString()}',
        ),
      );
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
        final result = await _repository.updateMedication(updated);

        if (result.isSuccess) {
          if (isPaused) {
            await _scheduler.cancelAllForMedication(id);
          } else {
            await _scheduler.rescheduleForMedication(updated);
          }

          final newList = currentState.medications
              .map((m) => m.id == id ? updated : m)
              .toList();
          final filtered = _applyFilters(newList);
          emit(currentState.copyWith(
            medications: newList,
            filteredMedications: filtered,
          ));
        } else {
          await loadMedications();
        }
      }
    } catch (e) {
      await loadMedications();
    }
  }

  /// Apply search, filter, and sort to the medication list.
  List<Medication> _applyFilters(List<Medication> medications) {
    var result = List<Medication>.from(medications);

    // Search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((m) {
        return m.name.toLowerCase().contains(query) ||
            m.dosageAmount.toLowerCase().contains(query) ||
            m.dosageUnit.toLowerCase().contains(query);
      }).toList();
    }

    // Filter
    switch (_filter) {
      case MedicationFilter.active:
        result = result.where((m) => !m.isPaused).toList();
      case MedicationFilter.paused:
        result = result.where((m) => m.isPaused).toList();
      case MedicationFilter.all:
        break;
    }

    // Sort
    switch (_sort) {
      case MedicationSort.name:
        result.sort((a, b) => a.name.compareTo(b.name));
      case MedicationSort.nextDose:
        result.sort((a, b) {
          final aTimes = parseScheduleTimes(a.scheduleTimes);
          final bTimes = parseScheduleTimes(b.scheduleTimes);
          if (aTimes.isEmpty && bTimes.isEmpty) return 0;
          if (aTimes.isEmpty) return 1;
          if (bTimes.isEmpty) return -1;
          return aTimes.first.compareTo(bTimes.first);
        });
      case MedicationSort.recentlyAdded:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }

  @override
  Future<void> close() {
    _watchSubscription?.cancel();
    return super.close();
  }
}
