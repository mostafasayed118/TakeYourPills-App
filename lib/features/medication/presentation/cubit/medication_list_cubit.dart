import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';

part 'medication_list_state.dart';

class MedicationListCubit extends Cubit<MedicationListState> {
  final MedicationRepositoryImpl _repository;

  MedicationListCubit(this._repository) : super(MedicationListInitial());

  Future<void> loadMedications() async {
    try {
      emit(MedicationListLoading());
      final medications = await _repository.getAllMedications();
      if (medications.isEmpty) {
        emit(MedicationListEmpty());
      } else {
        emit(MedicationListLoaded(medications: medications));
      }
    } catch (e) {
      emit(MedicationListError(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadMedications();
  }

  Future<void> deleteMedication(int id) async {
    try {
      if (state is MedicationListLoaded) {
        await _repository.deleteMedication(id);
        final current = (state as MedicationListLoaded).medications;
        final updated = current.where((m) => m.id != id).toList();
        if (updated.isEmpty) {
          emit(MedicationListEmpty());
        } else {
          emit(MedicationListLoaded(medications: updated));
        }
      }
    } catch (e) {
      emit(MedicationListError(message: 'Failed to delete medication: ${e.toString()}'));
    }
  }

  Future<void> pauseMedication(int id, bool isPaused) async {
    try {
      if (state is MedicationListLoaded) {
        final current = (state as MedicationListLoaded).medications;
        final med = current.firstWhere((m) => m.id == id);
        final updated = med.copyWith(isPaused: isPaused, updatedAt: DateTime.now());
        await _repository.updateMedication(updated);
        final newList = current.map((m) => m.id == id ? updated : m).toList();
        emit(MedicationListLoaded(medications: newList));
      }
    } catch (e) {
      // Revert on error by reloading
      await loadMedications();
    }
  }
}
