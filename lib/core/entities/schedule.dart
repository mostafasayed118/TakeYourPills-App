import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required int id,
    required int medicationId,
    required int hour, // 0-23
    required int minute, // 0-59
    @Default(127)
    int weekdaysBitfield, // bit 0=Mon, 1=Tue, ... 6=Sun; 127 = all days
    @Default(false) bool isAsNeeded,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
