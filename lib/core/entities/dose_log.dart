import 'package:freezed_annotation/freezed_annotation.dart';

part 'dose_log.freezed.dart';
part 'dose_log.g.dart';

/// Represents the status of a dose log entry.
enum DoseLogStatus {
  /// Dose is scheduled and awaiting action.
  pending,

  /// Dose was taken by the user.
  taken,

  /// Dose was snoozed by the user.
  snoozed,

  /// Dose was intentionally skipped.
  skipped,

  /// Dose was missed (past due without action).
  missed,
}

/// Extension providing human-readable labels for [DoseLogStatus].
extension DoseLogStatusX on DoseLogStatus {
  /// Returns a user-friendly label for this status.
  String get label => switch (this) {
      DoseLogStatus.pending => 'Pending',
      DoseLogStatus.taken => 'Taken',
      DoseLogStatus.snoozed => 'Snoozed',
      DoseLogStatus.skipped => 'Skipped',
      DoseLogStatus.missed => 'Missed',
    };
}

/// Immutable data model for a dose log entry.
///
/// Tracks medication intake events with scheduling and status information.
@freezed
abstract class DoseLog with _$DoseLog {
  const factory DoseLog({
    required int id,
    required int medicationId,
    required String scheduledTime,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? scheduleId,
    DateTime? actualTime,
    @JsonKey(unknownEnumValue: DoseLogStatus.pending)
    @Default(DoseLogStatus.pending)
    DoseLogStatus status,
    @Default(0) int snoozeCount,
    String? notes,
  }) = _DoseLog;

  factory DoseLog.fromJson(Map<String, dynamic> json) =>
      _$DoseLogFromJson(json);
}
