import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/error/result.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository.dart';
import 'package:takeyourpills_healthcare_app/shared/services/data_export_service.dart';

class MockMedicationRepository extends Mock implements MedicationRepository {}

void main() {
  late MockMedicationRepository repo;
  late DataExportService export;

  final med = Medication(
    id: 1,
    name: 'Aspirin',
    dosageAmount: '81',
    dosageUnit: 'mg',
    iconName: 'pill',
    scheduleTimes: '["08:00"]',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  final log = DoseLog(
    id: 10,
    medicationId: 1,
    scheduledTime: '2026-07-12T08:00:00.000',
    status: DoseLogStatus.taken,
    createdAt: DateTime(2026, 7, 12, 8),
    updatedAt: DateTime(2026, 7, 12, 8),
  );

  setUp(() {
    repo = MockMedicationRepository();
    export = DataExportService(repository: repo);
  });

  test('buildExportPayload includes medications and dose logs', () async {
    when(() => repo.getAllMedications()).thenAnswer(
      (_) async => Success([med]),
    );
    when(() => repo.getDoseLogsForMedication(1)).thenAnswer(
      (_) async => Success([log]),
    );

    final payload = await export.buildExportPayload();

    expect(payload['formatVersion'], DataExportService.exportFormatVersion);
    expect(payload['app'], 'TakeYourPills');
    expect(payload['medicationCount'], 1);
    expect(payload['doseLogCount'], 1);
    expect((payload['medications'] as List).single['name'], 'Aspirin');
    expect((payload['doseLogs'] as List).single['medicationId'], 1);
  });

  test('buildExportJson is valid JSON string', () async {
    when(() => repo.getAllMedications()).thenAnswer(
      (_) async => const Success(<Medication>[]),
    );

    final json = await export.buildExportJson();
    expect(json, contains('"formatVersion": 1'));
    expect(json, contains('"medications": []'));
  });
}
