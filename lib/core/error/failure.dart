import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_error.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.app(AppError error) = AppFailure;
}
