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

  /// Thrown when an email adress is trying to be signed up, which is
  /// already in use.
  const factory CustomAppException.userAlreadyExists() = UserAlreadyExists;

  /// Throw when the user enters invalid credentials.
  const factory CustomAppException.invalidCredentials() = InvalidCredentials;

  /// Thrown when the user is disabled.
  const factory CustomAppException.userDisabled() = UserDisabled;

  /// Thrown when there are some issues with the network.
  const factory CustomAppException.networkRequestFailed() =
      NetworkRequestFailed;

  /// Thrown when the user's email is not verified.
  const factory CustomAppException.emailNotVerified() = EmailNotVerified;
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
      invalidCredentials: () => CustomAppExceptionData(
        code: '008',
        message: loc.invalidCredentialsException,
      ),
      userDisabled: () => CustomAppExceptionData(
        code: '009',
        message: loc.userDisabledException,
      ),
      networkRequestFailed: () => CustomAppExceptionData(
        code: '010',
        message: loc.networkRequestFailedException,
      ),
      emailNotVerified: () => CustomAppExceptionData(
        code: '011',
        message: loc.emailNotVerifiedException,
      ),
      unexpected: (status) => CustomAppExceptionData(
        code: '500',
        message: loc.unexpectedException(status),
      ),
    );
  }
}
