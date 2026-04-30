import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
abstract class AppError with _$AppError {
  const factory AppError.database({required String message, String? code}) =
      DatabaseError;

  const factory AppError.notification({required String message, String? code}) =
      NotificationError;

  const factory AppError.permission({required String message, String? code}) =
      PermissionError;

  const factory AppError.validation({
    required String message,
    String? details,
  }) = ValidationError;

  const factory AppError.network({required String message, String? code}) =
      NetworkError;

  const factory AppError.unexpected({
    required String message,
    String? stackTrace,
  }) = UnexpectedError;

  const AppError._();

  String get displayMessage => when(
      database: (message, code) => 'Database error: $message',
      notification: (message, code) => 'Notification error: $message',
      permission: (message, code) => 'Permission denied: $message',
      validation: (message, details) => message,
      network: (message, code) => 'Network error: $message',
      unexpected: (message, stackTrace) => 'An unexpected error occurred',
    );
}
