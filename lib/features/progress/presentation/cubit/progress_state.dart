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

  double get adherencePercent =>
      scheduled > 0 ? (taken / scheduled * 100).clamp(0.0, 100.0) : 0.0;

  @override
  List<Object> get props => [day, taken, scheduled];
}

/// Single bar in the weekly chart.
class BarStat extends Equatable {
  const BarStat({
    required this.label,
    required this.adherencePercent,
    required this.taken,
    required this.scheduled,
  });

  final String label;
  final double adherencePercent;
  final int taken;
  final int scheduled;

  @override
  List<Object> get props => [label, adherencePercent, taken, scheduled];
}

/// Single point in the monthly line chart.
class LineStat extends Equatable {
  const LineStat({
    required this.day,
    required this.adherencePercent,
  });

  final DateTime day;
  final double adherencePercent;

  @override
  List<Object> get props => [day, adherencePercent];
}

/// View mode for the chart.
enum ChartView { week, month }

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
    required this.weeklyBars,
    required this.monthlyPoints,
    this.viewMode = ChartView.week,
  });

  final List<DayStat> stats;
  final int totalTaken;
  final int totalScheduled;
  final List<BarStat> weeklyBars;
  final List<LineStat> monthlyPoints;
  final ChartView viewMode;

  double get adherencePercent =>
      totalScheduled > 0
          ? (totalTaken / totalScheduled * 100).clamp(0.0, 100.0)
          : 0.0;

  ProgressLoaded copyWith({ChartView? viewMode}) => ProgressLoaded(
        stats: stats,
        totalTaken: totalTaken,
        totalScheduled: totalScheduled,
        weeklyBars: weeklyBars,
        monthlyPoints: monthlyPoints,
        viewMode: viewMode ?? this.viewMode,
      );

  @override
  List<Object?> get props => [
        stats,
        totalTaken,
        totalScheduled,
        weeklyBars,
        monthlyPoints,
        viewMode,
      ];
}

class ProgressError extends ProgressState {
  const ProgressError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
