import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_app_exception.freezed.dart';

/// Custom exceptions for the app.
@freezed
class CustomAppException with _$CustomAppException implements Exception {
  /// Entry not found exception.
  const factory CustomAppException.entryNotFound() = EntryNotFound;

  /// Time ranges overlap exception.
  const factory CustomAppException.timeRangesOverlap() = TimeRangesOverlap;

  /// Project not found exception.
  const factory CustomAppException.projectNotFound() = ProjectNotFound;

  /// Group not found exception.
  const factory CustomAppException.groupNotFound() = GroupNotFound;

  /// Multiple timer starts exception.
  const factory CustomAppException.multipleTimerStarts() = MultipleTimerStarts;

  /// Timer data not found exception.
  const factory CustomAppException.timerDataNotFound() = TimerDataNotFound;

  /// Unexpected exception.
  const factory CustomAppException.unexpected(String status) = Unexpected;

  /// User already exists exception.
  const factory CustomAppException.userAlreadyExists() = UserAlreadyExists;
}

/// Exception data for the custom exception
class CustomAppExceptionData {
  /// Exception data for the custom exception
  CustomAppExceptionData({
    required this.code,
    required this.message,
  });

  /// Exception code.
  final String code;

  /// Exception message.
  final String message;

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

/// Extension for the [CustomAppException] class.
extension CustomAppExceptioDetails on CustomAppException {
  /// Returns the [CustomAppExceptionData] instance.
  CustomAppExceptionData message(AppLocalizations loc) {
    return when(
      entryNotFound: () => CustomAppExceptionData(
        code: '001',
        message: loc.entryNotFoundException,
      ),
      timeRangesOverlap: () => CustomAppExceptionData(
        code: '002',
        message: loc.timeRangesOverlapException,
      ),
      projectNotFound: () => CustomAppExceptionData(
        code: '003',
        message: loc.projectNotFoundException,
      ),
      groupNotFound: () => CustomAppExceptionData(
        code: '004',
        message: loc.groupNotFoundException,
      ),
      multipleTimerStarts: () => CustomAppExceptionData(
        code: '005',
        message: loc.multipleTimerStartsException,
      ),
      timerDataNotFound: () => CustomAppExceptionData(
        code: '006',
        message: loc.timerDataNotFoundException,
      ),
      userAlreadyExists: () => CustomAppExceptionData(
        code: '007',
        message: loc.userAlreadyExistsException,
      ),
      unexpected: (status) => CustomAppExceptionData(
        code: '500',
        message: loc.unexpectedException(status),
      ),
    );
  }
}
