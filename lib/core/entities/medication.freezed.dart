// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medication {

 int get id; String get name; String get dosageAmount; String get dosageUnit; String get iconName; String get colorHex; String get frequencyType;// daily, weekly, as_needed, specific_days
 String get frequencyDays;// JSON-encoded list for specific_days
 int get frequencyInterval; String get scheduleTimes;// JSON-encoded list of "HH:mm" strings
 String? get startDate; String? get endDate; String? get instructions; bool get isPaused; int? get pillsRemaining; int? get refillThreshold; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);

  /// Serializes this Medication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosageAmount, dosageAmount) || other.dosageAmount == dosageAmount)&&(identical(other.dosageUnit, dosageUnit) || other.dosageUnit == dosageUnit)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.frequencyType, frequencyType) || other.frequencyType == frequencyType)&&(identical(other.frequencyDays, frequencyDays) || other.frequencyDays == frequencyDays)&&(identical(other.frequencyInterval, frequencyInterval) || other.frequencyInterval == frequencyInterval)&&(identical(other.scheduleTimes, scheduleTimes) || other.scheduleTimes == scheduleTimes)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.pillsRemaining, pillsRemaining) || other.pillsRemaining == pillsRemaining)&&(identical(other.refillThreshold, refillThreshold) || other.refillThreshold == refillThreshold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosageAmount,dosageUnit,iconName,colorHex,frequencyType,frequencyDays,frequencyInterval,scheduleTimes,startDate,endDate,instructions,isPaused,pillsRemaining,refillThreshold,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosageAmount: $dosageAmount, dosageUnit: $dosageUnit, iconName: $iconName, colorHex: $colorHex, frequencyType: $frequencyType, frequencyDays: $frequencyDays, frequencyInterval: $frequencyInterval, scheduleTimes: $scheduleTimes, startDate: $startDate, endDate: $endDate, instructions: $instructions, isPaused: $isPaused, pillsRemaining: $pillsRemaining, refillThreshold: $refillThreshold, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 int id, String name, String dosageAmount, String dosageUnit, String iconName, String colorHex, String frequencyType, String frequencyDays, int frequencyInterval, String scheduleTimes, String? startDate, String? endDate, String? instructions, bool isPaused, int? pillsRemaining, int? refillThreshold, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dosageAmount = null,Object? dosageUnit = null,Object? iconName = null,Object? colorHex = null,Object? frequencyType = null,Object? frequencyDays = null,Object? frequencyInterval = null,Object? scheduleTimes = null,Object? startDate = freezed,Object? endDate = freezed,Object? instructions = freezed,Object? isPaused = null,Object? pillsRemaining = freezed,Object? refillThreshold = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosageAmount: null == dosageAmount ? _self.dosageAmount : dosageAmount // ignore: cast_nullable_to_non_nullable
as String,dosageUnit: null == dosageUnit ? _self.dosageUnit : dosageUnit // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as String,frequencyDays: null == frequencyDays ? _self.frequencyDays : frequencyDays // ignore: cast_nullable_to_non_nullable
as String,frequencyInterval: null == frequencyInterval ? _self.frequencyInterval : frequencyInterval // ignore: cast_nullable_to_non_nullable
as int,scheduleTimes: null == scheduleTimes ? _self.scheduleTimes : scheduleTimes // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,pillsRemaining: freezed == pillsRemaining ? _self.pillsRemaining : pillsRemaining // ignore: cast_nullable_to_non_nullable
as int?,refillThreshold: freezed == refillThreshold ? _self.refillThreshold : refillThreshold // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String dosageAmount,  String dosageUnit,  String iconName,  String colorHex,  String frequencyType,  String frequencyDays,  int frequencyInterval,  String scheduleTimes,  String? startDate,  String? endDate,  String? instructions,  bool isPaused,  int? pillsRemaining,  int? refillThreshold,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosageAmount,_that.dosageUnit,_that.iconName,_that.colorHex,_that.frequencyType,_that.frequencyDays,_that.frequencyInterval,_that.scheduleTimes,_that.startDate,_that.endDate,_that.instructions,_that.isPaused,_that.pillsRemaining,_that.refillThreshold,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String dosageAmount,  String dosageUnit,  String iconName,  String colorHex,  String frequencyType,  String frequencyDays,  int frequencyInterval,  String scheduleTimes,  String? startDate,  String? endDate,  String? instructions,  bool isPaused,  int? pillsRemaining,  int? refillThreshold,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.name,_that.dosageAmount,_that.dosageUnit,_that.iconName,_that.colorHex,_that.frequencyType,_that.frequencyDays,_that.frequencyInterval,_that.scheduleTimes,_that.startDate,_that.endDate,_that.instructions,_that.isPaused,_that.pillsRemaining,_that.refillThreshold,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String dosageAmount,  String dosageUnit,  String iconName,  String colorHex,  String frequencyType,  String frequencyDays,  int frequencyInterval,  String scheduleTimes,  String? startDate,  String? endDate,  String? instructions,  bool isPaused,  int? pillsRemaining,  int? refillThreshold,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosageAmount,_that.dosageUnit,_that.iconName,_that.colorHex,_that.frequencyType,_that.frequencyDays,_that.frequencyInterval,_that.scheduleTimes,_that.startDate,_that.endDate,_that.instructions,_that.isPaused,_that.pillsRemaining,_that.refillThreshold,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Medication implements Medication {
  const _Medication({required this.id, required this.name, required this.dosageAmount, required this.dosageUnit, required this.iconName, this.colorHex = '', this.frequencyType = 'daily', this.frequencyDays = '', this.frequencyInterval = 1, this.scheduleTimes = '[]', this.startDate, this.endDate, this.instructions, this.isPaused = false, this.pillsRemaining, this.refillThreshold, required this.createdAt, required this.updatedAt});
  factory _Medication.fromJson(Map<String, dynamic> json) => _$MedicationFromJson(json);

@override final  int id;
@override final  String name;
@override final  String dosageAmount;
@override final  String dosageUnit;
@override final  String iconName;
@override@JsonKey() final  String colorHex;
@override@JsonKey() final  String frequencyType;
// daily, weekly, as_needed, specific_days
@override@JsonKey() final  String frequencyDays;
// JSON-encoded list for specific_days
@override@JsonKey() final  int frequencyInterval;
@override@JsonKey() final  String scheduleTimes;
// JSON-encoded list of "HH:mm" strings
@override final  String? startDate;
@override final  String? endDate;
@override final  String? instructions;
@override@JsonKey() final  bool isPaused;
@override final  int? pillsRemaining;
@override final  int? refillThreshold;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosageAmount, dosageAmount) || other.dosageAmount == dosageAmount)&&(identical(other.dosageUnit, dosageUnit) || other.dosageUnit == dosageUnit)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.frequencyType, frequencyType) || other.frequencyType == frequencyType)&&(identical(other.frequencyDays, frequencyDays) || other.frequencyDays == frequencyDays)&&(identical(other.frequencyInterval, frequencyInterval) || other.frequencyInterval == frequencyInterval)&&(identical(other.scheduleTimes, scheduleTimes) || other.scheduleTimes == scheduleTimes)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.pillsRemaining, pillsRemaining) || other.pillsRemaining == pillsRemaining)&&(identical(other.refillThreshold, refillThreshold) || other.refillThreshold == refillThreshold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosageAmount,dosageUnit,iconName,colorHex,frequencyType,frequencyDays,frequencyInterval,scheduleTimes,startDate,endDate,instructions,isPaused,pillsRemaining,refillThreshold,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosageAmount: $dosageAmount, dosageUnit: $dosageUnit, iconName: $iconName, colorHex: $colorHex, frequencyType: $frequencyType, frequencyDays: $frequencyDays, frequencyInterval: $frequencyInterval, scheduleTimes: $scheduleTimes, startDate: $startDate, endDate: $endDate, instructions: $instructions, isPaused: $isPaused, pillsRemaining: $pillsRemaining, refillThreshold: $refillThreshold, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String dosageAmount, String dosageUnit, String iconName, String colorHex, String frequencyType, String frequencyDays, int frequencyInterval, String scheduleTimes, String? startDate, String? endDate, String? instructions, bool isPaused, int? pillsRemaining, int? refillThreshold, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dosageAmount = null,Object? dosageUnit = null,Object? iconName = null,Object? colorHex = null,Object? frequencyType = null,Object? frequencyDays = null,Object? frequencyInterval = null,Object? scheduleTimes = null,Object? startDate = freezed,Object? endDate = freezed,Object? instructions = freezed,Object? isPaused = null,Object? pillsRemaining = freezed,Object? refillThreshold = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosageAmount: null == dosageAmount ? _self.dosageAmount : dosageAmount // ignore: cast_nullable_to_non_nullable
as String,dosageUnit: null == dosageUnit ? _self.dosageUnit : dosageUnit // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,frequencyType: null == frequencyType ? _self.frequencyType : frequencyType // ignore: cast_nullable_to_non_nullable
as String,frequencyDays: null == frequencyDays ? _self.frequencyDays : frequencyDays // ignore: cast_nullable_to_non_nullable
as String,frequencyInterval: null == frequencyInterval ? _self.frequencyInterval : frequencyInterval // ignore: cast_nullable_to_non_nullable
as int,scheduleTimes: null == scheduleTimes ? _self.scheduleTimes : scheduleTimes // ignore: cast_nullable_to_non_nullable
as String,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,pillsRemaining: freezed == pillsRemaining ? _self.pillsRemaining : pillsRemaining // ignore: cast_nullable_to_non_nullable
as int?,refillThreshold: freezed == refillThreshold ? _self.refillThreshold : refillThreshold // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
