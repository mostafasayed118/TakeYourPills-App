part of 'reminder_action_cubit.dart';

abstract class ReminderActionState extends Equatable {
  const ReminderActionState();

  @override
  List<Object> get props => [];
}

class ReminderActionInitial extends ReminderActionState {
  const ReminderActionInitial();
}

class ReminderActionLoading extends ReminderActionState {
  const ReminderActionLoading();
}

class ReminderActionSuccess extends ReminderActionState {
  const ReminderActionSuccess();
}

class ReminderActionError extends ReminderActionState {
  const ReminderActionError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
