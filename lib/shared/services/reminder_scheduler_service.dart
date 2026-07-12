import '../../core/entities/medication.dart';

/// Abstract interface for scheduling medication reminders.
///
/// Phase 3 will provide a concrete implementation using
/// `flutter_local_notifications`. This interface defines
/// the hooks needed by the medication CRUD flow.
abstract class ReminderSchedulerService {
  /// Schedule all reminders for a newly created medication.
  Future<void> scheduleForMedication(Medication medication);

  /// Reschedule all reminders for an updated medication.
  ///
  /// Typically cancels existing reminders, then re-creates them.
  Future<void> rescheduleForMedication(Medication medication);

  /// Cancel all reminders for a specific medication.
  Future<void> cancelAllForMedication(int medicationId);

  /// Cancel a single reminder by its notification ID.
  Future<void> cancelReminder(int notificationId);

  /// Cancel all reminders (e.g., app reset or user logout).
  Future<void> cancelAll();
}

/// No-op implementation used during development before Phase 3.
///
/// Prevents runtime errors when reminder hooks are called
/// but no notification service is configured yet.
class NoOpReminderSchedulerService implements ReminderSchedulerService {
  @override
  Future<void> scheduleForMedication(Medication medication) async {}

  @override
  Future<void> rescheduleForMedication(Medication medication) async {}

  @override
  Future<void> cancelAllForMedication(int medicationId) async {}

  @override
  Future<void> cancelReminder(int notificationId) async {}

  @override
  Future<void> cancelAll() async {}
}
