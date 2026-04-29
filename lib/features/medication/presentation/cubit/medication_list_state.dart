import 'package:equatable/equatable.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';

abstract class MedicationListState extends Equatable {
  const MedicationListState();

  @override
  List<Object> get props => [];
}

class MedicationListInitial extends MedicationListState {}

class MedicationListLoading extends MedicationListState {}

class MedicationListLoaded extends MedicationListState {
  final List<Medication> medications;

  const MedicationListLoaded({required this.medications});

  @override
  List<Object> get props => [medications];
}

class MedicationListEmpty extends MedicationListState {}

class MedicationListError extends MedicationListState {
  final String message;

  const MedicationListError({required this.message});

  @override
  List<Object> get props => [message];
}
