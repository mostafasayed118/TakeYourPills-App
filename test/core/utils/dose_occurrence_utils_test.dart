import 'package:flutter_test/flutter_test.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/utils/dose_occurrence_utils.dart';

void main() {
  final med = Medication(
    id: 1,
    name: 'Test',
    dosageAmount: '1',
    dosageUnit: 'pill',
    iconName: 'pill',
    scheduleTimes: '["08:00","20:00"]',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  test('occurrencesForRange expands daily doses across days', () {
    final start = DateTime(2026, 7, 13);
    final end = DateTime(2026, 7, 15);
    final occ = occurrencesForRange(
      medications: [med],
      rangeStart: start,
      rangeEnd: end,
    );
    // 2 days × 2 times
    expect(occ.length, 4);
    expect(occ.first.scheduledTime.hour, 8);
    expect(occ.last.scheduledTime.hour, 20);
  });

  test('skips paused and as_needed medications', () {
    final paused = med.copyWith(id: 2, isPaused: true);
    final prn = med.copyWith(id: 3, frequencyType: 'as_needed');
    final occ = occurrencesForRange(
      medications: [paused, prn],
      rangeStart: DateTime(2026, 7, 13),
      rangeEnd: DateTime(2026, 7, 14),
    );
    expect(occ, isEmpty);
  });

  test('formatTimeOfDay uses 12-hour clock', () {
    expect(formatTimeOfDay(DateTime(2026, 1, 1, 0, 5)), '12:05 AM');
    expect(formatTimeOfDay(DateTime(2026, 1, 1, 13, 30)), '1:30 PM');
  });
}
