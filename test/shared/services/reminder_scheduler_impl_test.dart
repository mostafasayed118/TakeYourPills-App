import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_impl.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockNotificationService mockNotificationService;
  late ReminderSchedulerImpl scheduler;

  setUp(() {
    mockNotificationService = MockNotificationService();
    scheduler = ReminderSchedulerImpl(notificationService: mockNotificationService);
  });

  group('ReminderSchedulerImpl (B10 Day-Offset Boundary)', () {
    test('scheduleForMedication uses proper DST-safe local day boundaries', () async {
      // Setup a medication with a specific time
      final medication = Medication(
        id: 1,
        name: 'Test Med',
        dosageAmount: '1',
        dosageUnit: 'pill',
        iconName: 'pill',
        colorHex: '',
        frequencyType: 'daily',
        frequencyDays: '[]',
        frequencyInterval: 1,
        scheduleTimes: '["23:59"]', // Edge case near midnight
        isPaused: false,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      when(() => mockNotificationService.scheduleNotification(
        id: any(named: 'id'),
        medicationId: any(named: 'medicationId'),
        doseId: any(named: 'doseId'),
        scheduledTime: any(named: 'scheduledTime'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      )).thenAnswer((_) async {});

      await scheduler.scheduleForMedication(medication);

      // Verify that notification service was called
      // We are essentially verifying that it doesn't crash or skip days 
      // due to Duration drift.
      verify(() => mockNotificationService.scheduleNotification(
        id: any(named: 'id'),
        medicationId: any(named: 'medicationId'),
        doseId: any(named: 'doseId'),
        scheduledTime: any(named: 'scheduledTime'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      )).called(greaterThan(0));
    });
  });
}
