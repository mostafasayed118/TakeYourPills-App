part of 'data_management_cubit.dart';

abstract class DataManagementState extends Equatable {
  const DataManagementState();

  @override
  List<Object?> get props => [];
}

class DataManagementInitial extends DataManagementState {
  const DataManagementInitial();
}

class DataManagementBusy extends DataManagementState {
  const DataManagementBusy();
}

class DataManagementSuccess extends DataManagementState {
  const DataManagementSuccess({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class DataManagementError extends DataManagementState {
  const DataManagementError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
