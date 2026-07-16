import '../../core/entities/medication.dart';
import '../../data/repositories/medication_repository.dart';

/// Abstract interface for scheduling medication reminders.
///
/// Concrete implementation uses `flutter_local_notifications`.
/// This interface defines the hooks needed by the medication CRUD flow.
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

  /// Cancel everything, then re-schedule active medications from [repository].
  ///
  /// Call on cold start so reboot / force-stop / OS cancellation does not
  /// leave the user without dose reminders.
  Future<void> rebuildFromRepository(MedicationRepository repository);
}

/// No-op implementation used in tests or when notifications are unavailable.
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

  @override
  Future<void> rebuildFromRepository(MedicationRepository repository) async {}
}
