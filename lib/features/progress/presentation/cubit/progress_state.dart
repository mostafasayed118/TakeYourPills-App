part of 'progress_cubit.dart';

class DayStat extends Equatable {
  const DayStat({
    required this.day,
    required this.taken,
    required this.scheduled,
  });

  final DateTime day;
  final int taken;
  final int scheduled;

  @override
  List<Object> get props => [day, taken, scheduled];
}

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoaded extends ProgressState {
  const ProgressLoaded({
    required this.stats,
    required this.totalTaken,
    required this.totalScheduled,
  });

  final List<DayStat> stats;
  final int totalTaken;
  final int totalScheduled;

  double get adherencePercent =>
      totalScheduled > 0 ? (totalTaken / totalScheduled * 100).clamp(0.0, 100.0) : 0.0;

  @override
  List<Object?> get props => [stats, totalTaken, totalScheduled];
}

class ProgressError extends ProgressState {
  const ProgressError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
