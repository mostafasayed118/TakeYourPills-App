// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {

 int get id; int get medicationId; int get hour;// 0-23
 int get minute;// 0-59
 int get weekdaysBitfield;// bit 0=Mon, 1=Tue, ... 6=Sun; 127 = all days
 bool get isAsNeeded;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.weekdaysBitfield, weekdaysBitfield) || other.weekdaysBitfield == weekdaysBitfield)&&(identical(other.isAsNeeded, isAsNeeded) || other.isAsNeeded == isAsNeeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,hour,minute,weekdaysBitfield,isAsNeeded);

@override
String toString() {
  return 'Schedule(id: $id, medicationId: $medicationId, hour: $hour, minute: $minute, weekdaysBitfield: $weekdaysBitfield, isAsNeeded: $isAsNeeded)';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
 int id, int medicationId, int hour, int minute, int weekdaysBitfield, bool isAsNeeded
});




}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? hour = null,Object? minute = null,Object? weekdaysBitfield = null,Object? isAsNeeded = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,weekdaysBitfield: null == weekdaysBitfield ? _self.weekdaysBitfield : weekdaysBitfield // ignore: cast_nullable_to_non_nullable
as int,isAsNeeded: null == isAsNeeded ? _self.isAsNeeded : isAsNeeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int medicationId,  int hour,  int minute,  int weekdaysBitfield,  bool isAsNeeded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.hour,_that.minute,_that.weekdaysBitfield,_that.isAsNeeded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int medicationId,  int hour,  int minute,  int weekdaysBitfield,  bool isAsNeeded)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.id,_that.medicationId,_that.hour,_that.minute,_that.weekdaysBitfield,_that.isAsNeeded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int medicationId,  int hour,  int minute,  int weekdaysBitfield,  bool isAsNeeded)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.hour,_that.minute,_that.weekdaysBitfield,_that.isAsNeeded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Schedule implements Schedule {
  const _Schedule({required this.id, required this.medicationId, required this.hour, required this.minute, this.weekdaysBitfield = 127, this.isAsNeeded = false});
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

@override final  int id;
@override final  int medicationId;
@override final  int hour;
// 0-23
@override final  int minute;
// 0-59
@override@JsonKey() final  int weekdaysBitfield;
// bit 0=Mon, 1=Tue, ... 6=Sun; 127 = all days
@override@JsonKey() final  bool isAsNeeded;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.weekdaysBitfield, weekdaysBitfield) || other.weekdaysBitfield == weekdaysBitfield)&&(identical(other.isAsNeeded, isAsNeeded) || other.isAsNeeded == isAsNeeded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,hour,minute,weekdaysBitfield,isAsNeeded);

@override
String toString() {
  return 'Schedule(id: $id, medicationId: $medicationId, hour: $hour, minute: $minute, weekdaysBitfield: $weekdaysBitfield, isAsNeeded: $isAsNeeded)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
 int id, int medicationId, int hour, int minute, int weekdaysBitfield, bool isAsNeeded
});




}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? hour = null,Object? minute = null,Object? weekdaysBitfield = null,Object? isAsNeeded = null,}) {
  return _then(_Schedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,weekdaysBitfield: null == weekdaysBitfield ? _self.weekdaysBitfield : weekdaysBitfield // ignore: cast_nullable_to_non_nullable
as int,isAsNeeded: null == isAsNeeded ? _self.isAsNeeded : isAsNeeded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
