// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  id: (json['id'] as num).toInt(),
  medicationId: (json['medicationId'] as num).toInt(),
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
  weekdaysBitfield: (json['weekdaysBitfield'] as num?)?.toInt() ?? 127,
  isAsNeeded: json['isAsNeeded'] as bool? ?? false,
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'medicationId': instance.medicationId,
  'hour': instance.hour,
  'minute': instance.minute,
  'weekdaysBitfield': instance.weekdaysBitfield,
  'isAsNeeded': instance.isAsNeeded,
};
