import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

class FakeMedication extends Fake implements Medication {}

void main() {
  late MockMedicationRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeMedication());
  });

  setUp(() {
    mockRepository = MockMedicationRepository();
  });

  group('MedicationFormCubit — create mode', () {
    late MedicationFormCubit cubit;

    setUp(() {
      cubit = MedicationFormCubit(repository: mockRepository);
    });

    tearDown(() => cubit.close());

    test('initial state is MedicationFormEditing with defaults', () {
      expect(cubit.state, isA<MedicationFormEditing>());
      final s = cubit.state as MedicationFormEditing;
      expect(s.name, '');
      expect(s.dosageUnit, 'mg');
      expect(s.frequencyType, 'daily');
      expect(s.isSaving, false);
      expect(s.isSuccess, false);
    });

    test('updateName changes name field', () {
      cubit.updateName('Aspirin');
      expect((cubit.state as MedicationFormEditing).name, 'Aspirin');
    });

    test('updateDosageAmount changes dosageAmount field', () {
      cubit.updateDosageAmount('100');
      expect((cubit.state as MedicationFormEditing).dosageAmount, '100');
    });

    test('updateFrequencyType changes frequencyType field', () {
      cubit.updateFrequencyType('weekly');
      expect((cubit.state as MedicationFormEditing).frequencyType, 'weekly');
    });

    blocTest<MedicationFormCubit, MedicationFormState>(
      'saveMedication emits validation error when name is empty',
      build: () => cubit,
      act: (c) {
                c.updateDosageAmount('10');
                c.updateScheduleTimes(['08:00']);
                c.saveMedication();
      },
      expect: () => [
        // updateDosageAmount
        isA<MedicationFormEditing>(),
        // updateScheduleTimes
        isA<MedicationFormEditing>(),
        // validation error
        isA<MedicationFormEditing>().having(
          (s) => s.validationError,
          'error',
          isNotNull,
        ),
      ],
    );

    blocTest<MedicationFormCubit, MedicationFormState>(
      'saveMedication emits validation error for invalid time format',
      build: () => cubit,
      act: (c) {
        c.updateName('Aspirin');
        c.updateDosageAmount('10');
        c.updateScheduleTimes(['25:99']);
        c.saveMedication();
      },
      expect: () => [
        isA<MedicationFormEditing>(), // name
        isA<MedicationFormEditing>(), // dosage
        isA<MedicationFormEditing>(), // schedule
        isA<MedicationFormEditing>().having(
          (s) => s.validationError,
          'error',
          contains('Invalid time'),
        ),
      ],
    );

    blocTest<MedicationFormCubit, MedicationFormState>(
      'saveMedication succeeds with valid data',
      build: () {
        when(
          () => mockRepository.createMedication(any()),
        ).thenAnswer((_) async => const Success(1));
        return cubit;
      },
      act: (c) {
        c.updateName('Aspirin');
                c.updateDosageAmount('100');
                c.updateScheduleTimes(['08:00']);
                c.saveMedication();
      },
      expect: () => [
        isA<MedicationFormEditing>(), // name
        isA<MedicationFormEditing>(), // dosage
        isA<MedicationFormEditing>(), // schedule
        isA<MedicationFormEditing>().having(
          (s) => s.isSaving,
          'isSaving',
          true,
        ),
        isA<MedicationFormSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepository.createMedication(any())).called(1);
      },
    );
  });

  group('MedicationFormCubit — edit mode', () {
    final existingMed = Medication(
      id: 42,
      name: 'Existing Med',
      dosageAmount: '50',
      dosageUnit: 'mg',
      iconName: 'pill',
      frequencyDays: '[]',
      scheduleTimes: '["08:00","20:00"]',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    blocTest<MedicationFormCubit, MedicationFormState>(
      'loads existing medication data in edit mode',
      build: () {
        when(
          () => mockRepository.getMedicationById(42),
        ).thenAnswer((_) async => Success<Medication?>(existingMed));
        return MedicationFormCubit(
          repository: mockRepository,
          isEditing: true,
          existingMedId: 42,
        );
      },
      expect: () => [
        isA<MedicationFormEditing>().having(
          (s) => s.name,
          'name',
          'Existing Med',
        ),
      ],
    );

    blocTest<MedicationFormCubit, MedicationFormState>(
      'emits error when medication not found in edit mode',
      build: () {
        when(
          () => mockRepository.getMedicationById(999),
        ).thenAnswer((_) async => const Success<Medication?>(null));
        return MedicationFormCubit(
          repository: mockRepository,
          isEditing: true,
          existingMedId: 999,
        );
      },
      expect: () => [
        isA<MedicationFormError>().having(
          (s) => s.message,
          'message',
          'Medication not found',
        ),
      ],
    );
  });
}
