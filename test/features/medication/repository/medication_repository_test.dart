import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/datasources/medication_local_datasource.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';

class MockMedicationLocalDatasource extends Mock implements MedicationLocalDatasource {}

void main() {
  late MockMedicationLocalDatasource mockDatasource;
  late MedicationRepositoryImpl repository;

  final testMedication = Medication(
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
  );

  setUp(() {
    mockDatasource = MockMedicationLocalDatasource();
    repository = MedicationRepositoryImpl(mockDatasource);
  });

  group('MedicationRepository — CRUD tests', () {
    test('createMedication returns ID on success', () async {
      when(
        () => mockDatasource.createMedication(testMedication),
      ).thenAnswer((_) async => 1);

      final result = await repository.createMedication(testMedication);

      expect(result, 1);
      verify(() => mockDatasource.createMedication(testMedication)).called(1);
    });

    test('getMedicationById returns medication when found', () async {
      when(
        () => mockDatasource.getMedicationById(1),
      ).thenAnswer((_) async => testMedication);

      final result = await repository.getMedicationById(1);

      expect(result, isNotNull);
      expect(result!.name, 'Aspirin');
      verify(() => mockDatasource.getMedicationById(1)).called(1);
    });

    test('getMedicationById returns null when not found', () async {
      when(
        () => mockDatasource.getMedicationById(999),
      ).thenAnswer((_) async => null);

      final result = await repository.getMedicationById(999);

      expect(result, isNull);
      verify(() => mockDatasource.getMedicationById(999)).called(1);
    });

    test('updateMedication returns rows affected', () async {
      final updatedMed = testMedication.copyWith(
        name: 'Updated Aspirin',
        dosageAmount: '200',
        updatedAt: DateTime.now(),
      );

      when(
        () => mockDatasource.updateMedication(updatedMed),
      ).thenAnswer((_) async => 1);

      final result = await repository.updateMedication(updatedMed);

      expect(result, 1);
      verify(() => mockDatasource.updateMedication(updatedMed)).called(1);
    });

    test('deleteMedication returns rows affected', () async {
      when(
        () => mockDatasource.deleteMedication(1),
      ).thenAnswer((_) async => 1);

      final result = await repository.deleteMedication(1);

      expect(result, 1);
      verify(() => mockDatasource.deleteMedication(1)).called(1);
    });

    test('getAllMedications returns list of medications', () async {
      final medications = [testMedication];
      when(
        () => mockDatasource.getAllMedications(),
      ).thenAnswer((_) async => medications);

      final result = await repository.getAllMedications();

      expect(result, hasLength(1));
      expect(result.first.name, 'Aspirin');
      verify(() => mockDatasource.getAllMedications()).called(1);
    });

    test('getActiveMedications filters paused medications', () async {
      final active = testMedication.copyWith(isPaused: false);
      when(
        () => mockDatasource.getActiveMedications(),
      ).thenAnswer((_) async => [active]);

      final result = await repository.getActiveMedications();

      expect(result, hasLength(1));
      expect(result.first.isPaused, false);
    });
  });
}
