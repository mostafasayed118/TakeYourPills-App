// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medication _$MedicationFromJson(Map<String, dynamic> json) => _Medication(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  dosageAmount: json['dosageAmount'] as String,
  dosageUnit: json['dosageUnit'] as String,
  iconName: json['iconName'] as String,
  colorHex: json['colorHex'] as String? ?? '',
  frequencyType: json['frequencyType'] as String? ?? 'daily',
  frequencyDays: json['frequencyDays'] as String? ?? '',
  frequencyInterval: (json['frequencyInterval'] as num?)?.toInt() ?? 1,
  scheduleTimes: json['scheduleTimes'] as String? ?? '[]',
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  instructions: json['instructions'] as String?,
  isPaused: json['isPaused'] as bool? ?? false,
  pillsRemaining: (json['pillsRemaining'] as num?)?.toInt(),
  refillThreshold: (json['refillThreshold'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MedicationToJson(_Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dosageAmount': instance.dosageAmount,
      'dosageUnit': instance.dosageUnit,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'frequencyType': instance.frequencyType,
      'frequencyDays': instance.frequencyDays,
      'frequencyInterval': instance.frequencyInterval,
      'scheduleTimes': instance.scheduleTimes,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'instructions': instance.instructions,
      'isPaused': instance.isPaused,
      'pillsRemaining': instance.pillsRemaining,
      'refillThreshold': instance.refillThreshold,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
