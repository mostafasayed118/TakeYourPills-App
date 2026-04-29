import 'package:freezed_annotation/freezed_annotation.dart';

part 'dose_log.freezed.dart';
part 'dose_log.g.dart';

enum DoseLogStatus { pending, taken, snoozed, skipped, missed }

extension DoseLogStatusX on DoseLogStatus {
  String get label {
    switch (this) {
      case DoseLogStatus.pending:
        return 'Pending';
      case DoseLogStatus.taken:
        return 'Taken';
      case DoseLogStatus.snoozed:
        return 'Snoozed';
      case DoseLogStatus.skipped:
        return 'Skipped';
      case DoseLogStatus.missed:
        return 'Missed';
    }
  }
}

@freezed
abstract class DoseLog with _$DoseLog {
  const factory DoseLog({
    required int id,
    required int medicationId,
    int? scheduleId,
    required String scheduledTime,
    DateTime? actualTime,
    @JsonKey(unknownEnumValue: DoseLogStatus.pending)
    @Default(DoseLogStatus.pending)
    DoseLogStatus status,
    @Default(0) int snoozeCount,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DoseLog;

  factory DoseLog.fromJson(Map<String, dynamic> json) =>
      _$DoseLogFromJson(json);
}
