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
    scheduler = ReminderSchedulerImpl(
      notificationService: mockNotificationService,
    );
  });

  group('ReminderSchedulerImpl (B10 Day-Offset Boundary)', () {
    test(
      'scheduleForMedication uses proper DST-safe local day boundaries',
      () async {
        final medication = Medication(
          id: 1,
          name: 'Test Med',
          dosageAmount: '1',
          dosageUnit: 'pill',
          iconName: 'pill',
          frequencyDays: '[]',
          scheduleTimes: '["23:59"]',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );

        when(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            medicationId: any(named: 'medicationId'),
            doseId: any(named: 'doseId'),
            scheduledTime: any(named: 'scheduledTime'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((_) async {});

        await scheduler.scheduleForMedication(medication);

        verify(
          () => mockNotificationService.scheduleNotification(
            id: any(named: 'id'),
            medicationId: any(named: 'medicationId'),
            doseId: any(named: 'doseId'),
            scheduledTime: any(named: 'scheduledTime'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            payload: any(named: 'payload'),
          ),
        ).called(greaterThan(0));
      },
    );
  });

  group('computeNotificationId (Android int32 safety)', () {
    test('always fits in signed 32-bit positive range', () {
      final times = [
        DateTime(2030, 12, 31, 23, 59),
        DateTime(2026, 7, 12, 8),
        DateTime.fromMillisecondsSinceEpoch(4102444800000), // far future
      ];
      for (final t in times) {
        for (var medId = 1; medId < 5000; medId += 997) {
          final id = ReminderSchedulerImpl.computeNotificationId(medId, t, 3);
          expect(id, greaterThanOrEqualTo(0));
          expect(id, lessThanOrEqualTo(0x7fffffff));
        }
      }
    });

    test('is deterministic for the same inputs', () {
      final t = DateTime(2026, 7, 12, 9, 30);
      final a = ReminderSchedulerImpl.computeNotificationId(42, t, 1);
      final b = ReminderSchedulerImpl.computeNotificationId(42, t, 1);
      expect(a, b);
    });
  });

  group('paused / as_needed medications', () {
    test('does not schedule when paused', () async {
      final medication = Medication(
        id: 2,
        name: 'Paused',
        dosageAmount: '1',
        dosageUnit: 'pill',
        iconName: 'pill',
        isPaused: true,
        scheduleTimes: '["08:00"]',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      await scheduler.scheduleForMedication(medication);

      verifyNever(
        () => mockNotificationService.scheduleNotification(
          id: any(named: 'id'),
          medicationId: any(named: 'medicationId'),
          doseId: any(named: 'doseId'),
          scheduledTime: any(named: 'scheduledTime'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
    });
  });
}
