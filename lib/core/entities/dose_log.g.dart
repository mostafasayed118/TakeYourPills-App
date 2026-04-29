// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoseLog _$DoseLogFromJson(Map<String, dynamic> json) => _DoseLog(
  id: (json['id'] as num).toInt(),
  medicationId: (json['medicationId'] as num).toInt(),
  scheduleId: (json['scheduleId'] as num?)?.toInt(),
  scheduledTime: json['scheduledTime'] as String,
  actualTime: json['actualTime'] == null
      ? null
      : DateTime.parse(json['actualTime'] as String),
  status:
      $enumDecodeNullable(
        _$DoseLogStatusEnumMap,
        json['status'],
        unknownValue: DoseLogStatus.pending,
      ) ??
      DoseLogStatus.pending,
  snoozeCount: (json['snoozeCount'] as num?)?.toInt() ?? 0,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DoseLogToJson(_DoseLog instance) => <String, dynamic>{
  'id': instance.id,
  'medicationId': instance.medicationId,
  'scheduleId': instance.scheduleId,
  'scheduledTime': instance.scheduledTime,
  'actualTime': instance.actualTime?.toIso8601String(),
  'status': _$DoseLogStatusEnumMap[instance.status]!,
  'snoozeCount': instance.snoozeCount,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$DoseLogStatusEnumMap = {
  DoseLogStatus.pending: 'pending',
  DoseLogStatus.taken: 'taken',
  DoseLogStatus.snoozed: 'snoozed',
  DoseLogStatus.skipped: 'skipped',
  DoseLogStatus.missed: 'missed',
};
