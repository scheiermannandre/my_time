// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  const factory AppException.entryNotFound() = EntryNotFound;
  const factory AppException.timeRangesOverlap() = TimeRangesOverlap;
  const factory AppException.projectNotFound() = ProjectNotFound;
  const factory AppException.groupNotFound() = GroupNotFound;

  const factory AppException.unexpected(String status) = Unexpected;
}

class AppExceptionData {
  AppExceptionData({
    required this.code,
    required this.message,
  });
  final String code;
  final String message;

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

extension AppExceptioDetails on AppException {
  AppExceptionData message(AppLocalizations loc) {
    return when(
      entryNotFound: () =>
          AppExceptionData(code: '001', message: loc.entryNotFoundException),
      timeRangesOverlap: () => AppExceptionData(
        code: '002',
        message: loc.timeRangesOverlapException,
      ),
      projectNotFound: () => AppExceptionData(
        code: '003',
        message: loc.projectNotFoundException,
      ),
      groupNotFound: () => AppExceptionData(
        code: '004',
        message: loc.groupNotFoundException,
      ),
      unexpected: (status) => AppExceptionData(
        code: '500',
        message: 'Unexpected error: $status',
      ),
    );
  }
}
