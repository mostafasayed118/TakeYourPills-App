part of 'dashboard_cubit.dart';

/// Base class for all dashboard states.
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class DashboardInitial extends DashboardState {}

/// Loading state while fetching dashboard data.
class DashboardLoading extends DashboardState {}

/// No medications exist.
class DashboardEmpty extends DashboardState {}

/// Successfully loaded dashboard data.
class DashboardLoaded extends DashboardState {

  const DashboardLoaded({
    required this.medications,
    required this.takenToday,
    required this.totalToday,
    required this.adherencePercent,
    required this.upcomingMedications, this.nextDose,
    this.nextDoseTime,
  });
  final List<Medication> medications;
  final int takenToday;
  final int totalToday;
  final double adherencePercent;
  final Medication? nextDose;
  final DateTime? nextDoseTime;
  final List<Medication> upcomingMedications;

  @override
  List<Object?> get props => [
    medications,
    takenToday,
    totalToday,
    adherencePercent,
    nextDose,
    nextDoseTime,
    upcomingMedications,
  ];
}

/// Error state with a human-readable message.
class DashboardError extends DashboardState {

  const DashboardError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
