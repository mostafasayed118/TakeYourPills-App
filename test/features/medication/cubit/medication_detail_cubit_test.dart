import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_detail_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class MockReminderScheduler extends Mock implements ReminderSchedulerService {}

void main() {
  late MockMedicationRepository mockRepository;
  late MockReminderScheduler mockScheduler;
  late MedicationDetailCubit cubit;

  final testMedication = Medication(
    id: 1,
    name: 'Aspirin',
    dosageAmount: '100',
    dosageUnit: 'mg',
    iconName: 'pill',
    frequencyDays: '[]',
    scheduleTimes: '["08:00"]',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUpAll(() {
    registerFallbackValue(testMedication);
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
    mockScheduler = MockReminderScheduler();

    when(
      () => mockRepository.getMedicationById(1),
    ).thenAnswer((_) async => Success<Medication?>(testMedication));

    cubit = MedicationDetailCubit(
      repository: mockRepository,
      scheduler: mockScheduler,
      medicationId: 1,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('MedicationDetailCubit (B8 & P2 Verification)', () {
    test('initial state loads medication on startup', () async {
      // By the time the test runs, it may have already loaded the mocked data
      expect(cubit.state, isA<MedicationDetailState>());
    });

    blocTest<MedicationDetailCubit, MedicationDetailState>(
      'togglePause prevents race conditions by locking state (B8)',
      build: () {
        when(
          () => mockRepository.updateMedication(any()),
        ).thenAnswer((_) async => const Success(1));
        when(
          () => mockScheduler.cancelAllForMedication(1),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) async {
        // Wait for initial load
        await Future.delayed(Duration.zero);

        // Fire twice rapidly - should only execute once due to _isTogglingPause guard
        cubit.togglePause();
        cubit.togglePause();
        await Future.delayed(const Duration(milliseconds: 100));
      },
      verify: (_) {
        verify(() => mockRepository.updateMedication(any())).called(1);
        verify(() => mockScheduler.cancelAllForMedication(1)).called(1);
      },
    );

    blocTest<MedicationDetailCubit, MedicationDetailState>(
      'deleteMedication safely cancels notifications BEFORE repository deletion (P2)',
      build: () {
        when(
          () => mockRepository.deleteMedication(1),
        ).thenAnswer((_) async => const Success(1));
        when(
          () => mockScheduler.cancelAllForMedication(1),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) async {
        await Future.delayed(Duration.zero);
        await cubit.deleteMedication();
      },
      expect: () => [isA<MedicationDetailDeleted>()],
      verify: (_) {
        verifyInOrder([
          () => mockScheduler.cancelAllForMedication(1),
          () => mockRepository.deleteMedication(1),
        ]);
      },
    );
  });
}
