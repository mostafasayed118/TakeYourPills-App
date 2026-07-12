/// Functional error handling with Result&lt;T&gt; type.
/// Provides exhaustive state handling without exceptions.
library;

import 'package:meta/meta.dart';

@immutable
sealed class Result<T> {
  const Result();

  /// Transforms the success value using [transform].
  Result<U> map<U>(U Function(T) transform);

  /// Transforms the failure value using [transform].
  Result<T> mapError(Object Function(Object error) transform);

  /// Returns true if this is a Success.
  bool get isSuccess;

  /// Returns true if this is a Failure.
  bool get isFailure;
}

/// Represents a successful operation with a value.
@immutable
final class Success<T> extends Result<T> {

  const Success(this.value);
  final T value;

  @override
  Result<U> map<U>(U Function(T) transform) => Success(transform(value));

  @override
  Result<T> mapError(Object Function(Object error) transform) => this;

  @override
  bool get isSuccess => true;

  @override
  bool get isFailure => false;

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed operation with an error.
@immutable
final class ResultFailure<T> extends Result<T> {

  const ResultFailure(this.error);
  final Object error;

  @override
  Result<U> map<U>(U Function(T) transform) => ResultFailure<U>(error);

  @override
  Result<T> mapError(Object Function(Object error) transform) =>
      ResultFailure<T>(transform(error));

  @override
  bool get isSuccess => false;

  @override
  bool get isFailure => true;

  @override
  String toString() => 'ResultFailure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

/// Extension methods for Result&lt;T&gt;.
extension ResultExtensions<T> on Result<T> {
  /// Executes [onSuccess] if this is a Success, otherwise [onFailure].
  U fold<U>(U Function(T) onSuccess, U Function(Object) onFailure) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure((this as ResultFailure<T>).error);
  }

  /// Returns the success value or [orElse] if failure.
  T getOrElse(T Function() orElse) {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return orElse();
  }

  /// Converts to nullable, returning null on failure.
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }
}

/// Helper functions for creating Results.
Result<T> success<T>(T value) => Success(value);
Result<T> resultFailure<T>(Object error) => ResultFailure(error);
