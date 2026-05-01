import 'package:flutter_test/flutter_test.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart' as domain;
import 'package:takeyourpills_healthcare_app/data/database/app_database.dart';
import 'package:takeyourpills_healthcare_app/data/database/mappers/dose_log_mapper.dart';

void main() {
  group('DoseLogMapper (B9 Enum Bounds Safety)', () {
    test('safely parses out of bounds enum index to pending', () {
      final outOfBoundsModel = DoseLogData(
        id: 1,
        medicationId: 1,
        scheduledTime: '08:00',
        status: 999, // Out of bounds index
        snoozeCount: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      final entity = DoseLogMapper.toEntity(outOfBoundsModel);
      
      // Should fallback to pending instead of throwing RangeError
      expect(entity.status, domain.DoseLogStatus.pending);
    });

    test('safely parses negative enum index to pending', () {
      final negativeBoundsModel = DoseLogData(
        id: 1,
        medicationId: 1,
        scheduledTime: '08:00',
        status: -1, // Negative out of bounds index
        snoozeCount: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      final entity = DoseLogMapper.toEntity(negativeBoundsModel);
      
      expect(entity.status, domain.DoseLogStatus.pending);
    });

    test('parses valid enum index correctly', () {
      final validModel = DoseLogData(
        id: 1,
        medicationId: 1,
        scheduledTime: '08:00',
        status: domain.DoseLogStatus.taken.index, // Valid index
        snoozeCount: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      final entity = DoseLogMapper.toEntity(validModel);
      
      expect(entity.status, domain.DoseLogStatus.taken);
    });
  });
}
