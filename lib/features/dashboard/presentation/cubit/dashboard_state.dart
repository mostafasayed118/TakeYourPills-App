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
    this.nextDose,
    this.nextDoseTime,
    required this.upcomingMedications,
    this.doseOccurrences = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.streakMessage = '',
    this.isTakingDose = false,
  });

  final List<Medication> medications;
  final int takenToday;
  final int totalToday;
  final double adherencePercent;
  final Medication? nextDose;
  final DateTime? nextDoseTime;
  final List<Medication> upcomingMedications;
  final List<ScheduledDose> doseOccurrences;
  final int currentStreak;
  final int bestStreak;
  final String streakMessage;
  final bool isTakingDose;

  DashboardLoaded copyWith({bool? isTakingDose}) => DashboardLoaded(
        medications: medications,
        takenToday: takenToday,
        totalToday: totalToday,
        adherencePercent: adherencePercent,
        nextDose: nextDose,
        nextDoseTime: nextDoseTime,
        upcomingMedications: upcomingMedications,
        doseOccurrences: doseOccurrences,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
        streakMessage: streakMessage,
        isTakingDose: isTakingDose ?? this.isTakingDose,
      );

  @override
  List<Object?> get props => [
        medications,
        takenToday,
        totalToday,
        adherencePercent,
        nextDose,
        nextDoseTime,
        upcomingMedications,
        doseOccurrences,
        currentStreak,
        bestStreak,
        streakMessage,
        isTakingDose,
      ];
}

/// Error state with a human-readable message.
class DashboardError extends DashboardState {
  const DashboardError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
