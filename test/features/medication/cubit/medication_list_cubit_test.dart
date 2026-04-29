import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository mockRepository;
  late MedicationListCubit cubit;

  final testMedications = [
    Medication(
      id: 1,
      name: 'Aspirin',
      dosageAmount: '100',
      dosageUnit: 'mg',
      iconName: 'pill',
      colorHex: '',
      frequencyType: 'daily',
      frequencyDays: '[]',
      frequencyInterval: 1,
      scheduleTimes: '["08:00"]',
      isPaused: false,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    Medication(
      id: 2,
      name: 'Lisinopril',
      dosageAmount: '10',
      dosageUnit: 'mg',
      iconName: 'pill',
      colorHex: '',
      frequencyType: 'daily',
      frequencyDays: '[]',
      frequencyInterval: 1,
      scheduleTimes: '["09:00","21:00"]',
      isPaused: false,
      createdAt: DateTime(2026, 1, 2),
      updatedAt: DateTime(2026, 1, 2),
    ),
  ];

  setUp(() {
    mockRepository = MockMedicationRepository();
    cubit = MedicationListCubit(mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('MedicationListCubit', () {
    test('initial state is MedicationListInitial', () {
      expect(cubit.state, isA<MedicationListInitial>());
    });

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Loaded] when loadMedications succeeds with data',
      build: () {
        when(() => mockRepository.getAllMedications())
            .thenAnswer((_) async => testMedications);
        return cubit;
      },
      act: (cubit) => cubit.loadMedications(),
      expect: () => [
        isA<MedicationListLoading>(),
        isA<MedicationListLoaded>().having(
          (s) => s.medications.length,
          'medications count',
          2,
        ),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Empty] when loadMedications returns empty list',
      build: () {
        when(() => mockRepository.getAllMedications())
            .thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.loadMedications(),
      expect: () => [
        isA<MedicationListLoading>(),
        isA<MedicationListEmpty>(),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'emits [Loading, Error] when loadMedications throws',
      build: () {
        when(() => mockRepository.getAllMedications())
            .thenThrow(Exception('DB error'));
        return cubit;
      },
      act: (cubit) => cubit.loadMedications(),
      expect: () => [
        isA<MedicationListLoading>(),
        isA<MedicationListError>(),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'deleteMedication removes item and emits updated list',
      build: () {
        when(() => mockRepository.getAllMedications())
            .thenAnswer((_) async => testMedications);
        when(() => mockRepository.deleteMedication(1))
            .thenAnswer((_) async => 1);
        return cubit;
      },
      seed: () => MedicationListLoaded(medications: testMedications),
      act: (cubit) => cubit.deleteMedication(1),
      expect: () => [
        isA<MedicationListLoaded>().having(
          (s) => s.medications.length,
          'remaining count',
          1,
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteMedication(1)).called(1);
      },
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'deleteMedication emits Empty when last medication deleted',
      build: () {
        when(() => mockRepository.deleteMedication(1))
            .thenAnswer((_) async => 1);
        return cubit;
      },
      seed: () => MedicationListLoaded(
        medications: [testMedications.first],
      ),
      act: (cubit) => cubit.deleteMedication(1),
      expect: () => [
        isA<MedicationListEmpty>(),
      ],
    );

    blocTest<MedicationListCubit, MedicationListState>(
      'pauseMedication updates isPaused state',
      build: () {
        when(() => mockRepository.updateMedication(any()))
            .thenAnswer((_) async => 1);
        return cubit;
      },
      seed: () => MedicationListLoaded(medications: testMedications),
      act: (cubit) => cubit.pauseMedication(1, true),
      expect: () => [
        isA<MedicationListLoaded>().having(
          (s) => s.medications.firstWhere((m) => m.id == 1).isPaused,
          'isPaused',
          true,
        ),
      ],
    );
  });
}
