// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppError {

 String get message;
/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppErrorCopyWith<AppError> get copyWith => _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError(message: $message)';
}


}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res>  {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) = _$AppErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AppErrorCopyWithImpl<$Res>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DatabaseError value)?  database,TResult Function( NotificationError value)?  notification,TResult Function( PermissionError value)?  permission,TResult Function( ValidationError value)?  validation,TResult Function( NetworkError value)?  network,TResult Function( UnexpectedError value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DatabaseError() when database != null:
return database(_that);case NotificationError() when notification != null:
return notification(_that);case PermissionError() when permission != null:
return permission(_that);case ValidationError() when validation != null:
return validation(_that);case NetworkError() when network != null:
return network(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DatabaseError value)  database,required TResult Function( NotificationError value)  notification,required TResult Function( PermissionError value)  permission,required TResult Function( ValidationError value)  validation,required TResult Function( NetworkError value)  network,required TResult Function( UnexpectedError value)  unexpected,}){
final _that = this;
switch (_that) {
case DatabaseError():
return database(_that);case NotificationError():
return notification(_that);case PermissionError():
return permission(_that);case ValidationError():
return validation(_that);case NetworkError():
return network(_that);case UnexpectedError():
return unexpected(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DatabaseError value)?  database,TResult? Function( NotificationError value)?  notification,TResult? Function( PermissionError value)?  permission,TResult? Function( ValidationError value)?  validation,TResult? Function( NetworkError value)?  network,TResult? Function( UnexpectedError value)?  unexpected,}){
final _that = this;
switch (_that) {
case DatabaseError() when database != null:
return database(_that);case NotificationError() when notification != null:
return notification(_that);case PermissionError() when permission != null:
return permission(_that);case ValidationError() when validation != null:
return validation(_that);case NetworkError() when network != null:
return network(_that);case UnexpectedError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message,  String? code)?  database,TResult Function( String message,  String? code)?  notification,TResult Function( String message,  String? code)?  permission,TResult Function( String message,  String? details)?  validation,TResult Function( String message,  String? code)?  network,TResult Function( String message,  String? stackTrace)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DatabaseError() when database != null:
return database(_that.message,_that.code);case NotificationError() when notification != null:
return notification(_that.message,_that.code);case PermissionError() when permission != null:
return permission(_that.message,_that.code);case ValidationError() when validation != null:
return validation(_that.message,_that.details);case NetworkError() when network != null:
return network(_that.message,_that.code);case UnexpectedError() when unexpected != null:
return unexpected(_that.message,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message,  String? code)  database,required TResult Function( String message,  String? code)  notification,required TResult Function( String message,  String? code)  permission,required TResult Function( String message,  String? details)  validation,required TResult Function( String message,  String? code)  network,required TResult Function( String message,  String? stackTrace)  unexpected,}) {final _that = this;
switch (_that) {
case DatabaseError():
return database(_that.message,_that.code);case NotificationError():
return notification(_that.message,_that.code);case PermissionError():
return permission(_that.message,_that.code);case ValidationError():
return validation(_that.message,_that.details);case NetworkError():
return network(_that.message,_that.code);case UnexpectedError():
return unexpected(_that.message,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message,  String? code)?  database,TResult? Function( String message,  String? code)?  notification,TResult? Function( String message,  String? code)?  permission,TResult? Function( String message,  String? details)?  validation,TResult? Function( String message,  String? code)?  network,TResult? Function( String message,  String? stackTrace)?  unexpected,}) {final _that = this;
switch (_that) {
case DatabaseError() when database != null:
return database(_that.message,_that.code);case NotificationError() when notification != null:
return notification(_that.message,_that.code);case PermissionError() when permission != null:
return permission(_that.message,_that.code);case ValidationError() when validation != null:
return validation(_that.message,_that.details);case NetworkError() when network != null:
return network(_that.message,_that.code);case UnexpectedError() when unexpected != null:
return unexpected(_that.message,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class DatabaseError extends AppError {
  const DatabaseError({required this.message, this.code}): super._();
  

@override final  String message;
 final  String? code;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseErrorCopyWith<DatabaseError> get copyWith => _$DatabaseErrorCopyWithImpl<DatabaseError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AppError.database(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $DatabaseErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $DatabaseErrorCopyWith(DatabaseError value, $Res Function(DatabaseError) _then) = _$DatabaseErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$DatabaseErrorCopyWithImpl<$Res>
    implements $DatabaseErrorCopyWith<$Res> {
  _$DatabaseErrorCopyWithImpl(this._self, this._then);

  final DatabaseError _self;
  final $Res Function(DatabaseError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(DatabaseError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotificationError extends AppError {
  const NotificationError({required this.message, this.code}): super._();
  

@override final  String message;
 final  String? code;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationErrorCopyWith<NotificationError> get copyWith => _$NotificationErrorCopyWithImpl<NotificationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AppError.notification(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NotificationErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $NotificationErrorCopyWith(NotificationError value, $Res Function(NotificationError) _then) = _$NotificationErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NotificationErrorCopyWithImpl<$Res>
    implements $NotificationErrorCopyWith<$Res> {
  _$NotificationErrorCopyWithImpl(this._self, this._then);

  final NotificationError _self;
  final $Res Function(NotificationError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NotificationError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PermissionError extends AppError {
  const PermissionError({required this.message, this.code}): super._();
  

@override final  String message;
 final  String? code;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionErrorCopyWith<PermissionError> get copyWith => _$PermissionErrorCopyWithImpl<PermissionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AppError.permission(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $PermissionErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $PermissionErrorCopyWith(PermissionError value, $Res Function(PermissionError) _then) = _$PermissionErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$PermissionErrorCopyWithImpl<$Res>
    implements $PermissionErrorCopyWith<$Res> {
  _$PermissionErrorCopyWithImpl(this._self, this._then);

  final PermissionError _self;
  final $Res Function(PermissionError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(PermissionError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ValidationError extends AppError {
  const ValidationError({required this.message, this.details}): super._();
  

@override final  String message;
 final  String? details;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationErrorCopyWith<ValidationError> get copyWith => _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationError&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,message,details);

@override
String toString() {
  return 'AppError.validation(message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(ValidationError value, $Res Function(ValidationError) _then) = _$ValidationErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? details
});




}
/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? details = freezed,}) {
  return _then(ValidationError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NetworkError extends AppError {
  const NetworkError({required this.message, this.code}): super._();
  

@override final  String message;
 final  String? code;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'AppError.network(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? code
});




}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,}) {
  return _then(NetworkError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnexpectedError extends AppError {
  const UnexpectedError({required this.message, this.stackTrace}): super._();
  

@override final  String message;
 final  String? stackTrace;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedErrorCopyWith<UnexpectedError> get copyWith => _$UnexpectedErrorCopyWithImpl<UnexpectedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedError&&(identical(other.message, message) || other.message == message)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,stackTrace);

@override
String toString() {
  return 'AppError.unexpected(message: $message, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnexpectedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnexpectedErrorCopyWith(UnexpectedError value, $Res Function(UnexpectedError) _then) = _$UnexpectedErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String? stackTrace
});




}
/// @nodoc
class _$UnexpectedErrorCopyWithImpl<$Res>
    implements $UnexpectedErrorCopyWith<$Res> {
  _$UnexpectedErrorCopyWithImpl(this._self, this._then);

  final UnexpectedError _self;
  final $Res Function(UnexpectedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? stackTrace = freezed,}) {
  return _then(UnexpectedError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
