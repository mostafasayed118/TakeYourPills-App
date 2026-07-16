part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props;
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();

  @override
  List<Object?> get props => [];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading({
    required this.weekStart,
    required this.selectedDay,
  });

  final DateTime weekStart;
  final DateTime selectedDay;

  CalendarLoading copyWith({DateTime? weekStart, DateTime? selectedDay}) =>
      CalendarLoading(
        weekStart: weekStart ?? this.weekStart,
        selectedDay: selectedDay ?? this.selectedDay,
      );

  @override
  List<Object?> get props => [weekStart, selectedDay];
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded({
    required this.weekStart,
    required this.selectedDay,
    required this.medications,
    required this.doseLogs,
  });

  final DateTime weekStart;
  final DateTime selectedDay;
  final List<Medication> medications;
  final List<DoseLog> doseLogs;

  CalendarLoaded copyWith({
    DateTime? weekStart,
    DateTime? selectedDay,
    List<Medication>? medications,
    List<DoseLog>? doseLogs,
  }) =>
      CalendarLoaded(
        weekStart: weekStart ?? this.weekStart,
        selectedDay: selectedDay ?? this.selectedDay,
        medications: medications ?? this.medications,
        doseLogs: doseLogs ?? this.doseLogs,
      );

  @override
  List<Object?> get props => [weekStart, selectedDay, medications, doseLogs];
}

class CalendarError extends CalendarState {
  const CalendarError({
    required this.message,
    required this.weekStart,
    required this.selectedDay,
  });

  final String message;
  final DateTime weekStart;
  final DateTime selectedDay;

  CalendarError copyWith({
    String? message,
    DateTime? weekStart,
    DateTime? selectedDay,
  }) =>
      CalendarError(
        message: message ?? this.message,
        weekStart: weekStart ?? this.weekStart,
        selectedDay: selectedDay ?? this.selectedDay,
      );

  @override
  List<Object?> get props => [message, weekStart, selectedDay];
}
