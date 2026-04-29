import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
class AppError with _$AppError {
  const factory AppError.database(String message) = DatabaseError;
  const factory AppError.network(String message) = NetworkError;
  const factory AppError.validation(String message) = ValidationError;
  const factory AppError.notification(String message) = NotificationError;
  const factory AppError.permission(String message) = PermissionError;
  const factory AppError.unexpected(String message) = UnexpectedError;
}
