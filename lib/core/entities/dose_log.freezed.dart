// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoseLog {

 int get id; int get medicationId; String get scheduledTime; DateTime get createdAt; DateTime get updatedAt; int? get scheduleId; DateTime? get actualTime;@JsonKey(unknownEnumValue: DoseLogStatus.pending) DoseLogStatus get status; int get snoozeCount; String? get notes;
/// Create a copy of DoseLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseLogCopyWith<DoseLog> get copyWith => _$DoseLogCopyWithImpl<DoseLog>(this as DoseLog, _$identity);

  /// Serializes this DoseLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoseLog&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.actualTime, actualTime) || other.actualTime == actualTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduledTime,createdAt,updatedAt,scheduleId,actualTime,status,snoozeCount,notes);

@override
String toString() {
  return 'DoseLog(id: $id, medicationId: $medicationId, scheduledTime: $scheduledTime, createdAt: $createdAt, updatedAt: $updatedAt, scheduleId: $scheduleId, actualTime: $actualTime, status: $status, snoozeCount: $snoozeCount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $DoseLogCopyWith<$Res>  {
  factory $DoseLogCopyWith(DoseLog value, $Res Function(DoseLog) _then) = _$DoseLogCopyWithImpl;
@useResult
$Res call({
 int id, int medicationId, String scheduledTime, DateTime createdAt, DateTime updatedAt, int? scheduleId, DateTime? actualTime,@JsonKey(unknownEnumValue: DoseLogStatus.pending) DoseLogStatus status, int snoozeCount, String? notes
});




}
/// @nodoc
class _$DoseLogCopyWithImpl<$Res>
    implements $DoseLogCopyWith<$Res> {
  _$DoseLogCopyWithImpl(this._self, this._then);

  final DoseLog _self;
  final $Res Function(DoseLog) _then;

/// Create a copy of DoseLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? scheduledTime = null,Object? createdAt = null,Object? updatedAt = null,Object? scheduleId = freezed,Object? actualTime = freezed,Object? status = null,Object? snoozeCount = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as int,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int?,actualTime: freezed == actualTime ? _self.actualTime : actualTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseLogStatus,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoseLog].
extension DoseLogPatterns on DoseLog {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoseLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoseLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoseLog value)  $default,){
final _that = this;
switch (_that) {
case _DoseLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoseLog value)?  $default,){
final _that = this;
switch (_that) {
case _DoseLog() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int medicationId,  String scheduledTime,  DateTime createdAt,  DateTime updatedAt,  int? scheduleId,  DateTime? actualTime, @JsonKey(unknownEnumValue: DoseLogStatus.pending)  DoseLogStatus status,  int snoozeCount,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoseLog() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduledTime,_that.createdAt,_that.updatedAt,_that.scheduleId,_that.actualTime,_that.status,_that.snoozeCount,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int medicationId,  String scheduledTime,  DateTime createdAt,  DateTime updatedAt,  int? scheduleId,  DateTime? actualTime, @JsonKey(unknownEnumValue: DoseLogStatus.pending)  DoseLogStatus status,  int snoozeCount,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _DoseLog():
return $default(_that.id,_that.medicationId,_that.scheduledTime,_that.createdAt,_that.updatedAt,_that.scheduleId,_that.actualTime,_that.status,_that.snoozeCount,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int medicationId,  String scheduledTime,  DateTime createdAt,  DateTime updatedAt,  int? scheduleId,  DateTime? actualTime, @JsonKey(unknownEnumValue: DoseLogStatus.pending)  DoseLogStatus status,  int snoozeCount,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _DoseLog() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduledTime,_that.createdAt,_that.updatedAt,_that.scheduleId,_that.actualTime,_that.status,_that.snoozeCount,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoseLog implements DoseLog {
  const _DoseLog({required this.id, required this.medicationId, required this.scheduledTime, required this.createdAt, required this.updatedAt, this.scheduleId, this.actualTime, @JsonKey(unknownEnumValue: DoseLogStatus.pending) this.status = DoseLogStatus.pending, this.snoozeCount = 0, this.notes});
  factory _DoseLog.fromJson(Map<String, dynamic> json) => _$DoseLogFromJson(json);

@override final  int id;
@override final  int medicationId;
@override final  String scheduledTime;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  int? scheduleId;
@override final  DateTime? actualTime;
@override@JsonKey(unknownEnumValue: DoseLogStatus.pending) final  DoseLogStatus status;
@override@JsonKey() final  int snoozeCount;
@override final  String? notes;

/// Create a copy of DoseLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseLogCopyWith<_DoseLog> get copyWith => __$DoseLogCopyWithImpl<_DoseLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoseLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoseLog&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.actualTime, actualTime) || other.actualTime == actualTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.snoozeCount, snoozeCount) || other.snoozeCount == snoozeCount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduledTime,createdAt,updatedAt,scheduleId,actualTime,status,snoozeCount,notes);

@override
String toString() {
  return 'DoseLog(id: $id, medicationId: $medicationId, scheduledTime: $scheduledTime, createdAt: $createdAt, updatedAt: $updatedAt, scheduleId: $scheduleId, actualTime: $actualTime, status: $status, snoozeCount: $snoozeCount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$DoseLogCopyWith<$Res> implements $DoseLogCopyWith<$Res> {
  factory _$DoseLogCopyWith(_DoseLog value, $Res Function(_DoseLog) _then) = __$DoseLogCopyWithImpl;
@override @useResult
$Res call({
 int id, int medicationId, String scheduledTime, DateTime createdAt, DateTime updatedAt, int? scheduleId, DateTime? actualTime,@JsonKey(unknownEnumValue: DoseLogStatus.pending) DoseLogStatus status, int snoozeCount, String? notes
});




}
/// @nodoc
class __$DoseLogCopyWithImpl<$Res>
    implements _$DoseLogCopyWith<$Res> {
  __$DoseLogCopyWithImpl(this._self, this._then);

  final _DoseLog _self;
  final $Res Function(_DoseLog) _then;

/// Create a copy of DoseLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? scheduledTime = null,Object? createdAt = null,Object? updatedAt = null,Object? scheduleId = freezed,Object? actualTime = freezed,Object? status = null,Object? snoozeCount = null,Object? notes = freezed,}) {
  return _then(_DoseLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as int,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int?,actualTime: freezed == actualTime ? _self.actualTime : actualTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseLogStatus,snoozeCount: null == snoozeCount ? _self.snoozeCount : snoozeCount // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
