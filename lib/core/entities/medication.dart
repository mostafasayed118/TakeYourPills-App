import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

@freezed
class Medication with _$Medication {
  const factory Medication({
    required int id,
    required String name,
    required String dosageAmount,
    required String dosageUnit,
    required String iconName,
    @Default('') String colorHex,
    @Default('daily') String frequencyType, // daily, weekly, as_needed, specific_days
    @Default('') String frequencyDays, // JSON-encoded list for specific_days
    @Default(1) int frequencyInterval,
    @Default('[]') String scheduleTimes, // JSON-encoded list of "HH:mm" strings
    String? startDate,
    String? endDate,
    String? instructions,
    @Default(false) bool isPaused,
    int? pillsRemaining,
    int? refillThreshold,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
}
