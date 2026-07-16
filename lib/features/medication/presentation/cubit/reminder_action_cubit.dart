import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

part 'reminder_action_state.dart';

class ReminderActionCubit extends Cubit<ReminderActionState> {
  ReminderActionCubit({
    required this.medicationId,
    required this.doseId,
    required this.scheduledTime,
    required MedicationRepository repository,
    required ReminderSchedulerService scheduler,
    required NotificationService notificationService,
  })  : _repository = repository,
        _scheduler = scheduler,
        _notificationService = notificationService,
        super(const ReminderActionInitial());

  final int medicationId;
  final int doseId;
  final DateTime scheduledTime;

  final MedicationRepository _repository;
  final ReminderSchedulerService _scheduler;
  final NotificationService _notificationService;

  Future<void> _recordDose(DoseLogStatus status) async {
    emit(const ReminderActionLoading());
    try {
      final doseLog = DoseLog(
        id: 0,
        medicationId: medicationId,
        scheduledTime: scheduledTime.toIso8601String(),
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.createDoseLog(doseLog);
      await _scheduler.cancelReminder(doseId);
      emit(const ReminderActionSuccess());
    } catch (e) {
      emit(ReminderActionError(e.toString()));
    }
  }

  Future<void> takeDose() async => _recordDose(DoseLogStatus.taken);

  Future<void> skipDose() async => _recordDose(DoseLogStatus.skipped);

  Future<void> snoozeDose(int minutes) async {
    emit(const ReminderActionLoading());
    try {
      final newScheduledTime = scheduledTime.add(Duration(minutes: minutes));
      final result = await _repository.getMedicationById(medicationId);

      result.fold(
        (med) async {
          if (med != null) {
            await _notificationService.scheduleNotification(
              id: doseId,
              medicationId: medicationId,
              doseId: doseId,
              scheduledTime: newScheduledTime,
              title: 'Time for ${med.name}',
              body: '${med.dosageAmount} ${med.dosageUnit}',
              payload: '$medicationId,$doseId,${newScheduledTime.toIso8601String()}',
            );
            emit(const ReminderActionSuccess());
          } else {
            emit(const ReminderActionError('Medication not found for snooze'));
          }
        },
        (error) => emit(ReminderActionError(error.toString())),
      );
    } catch (e) {
      emit(ReminderActionError(e.toString()));
    }
  }
}
