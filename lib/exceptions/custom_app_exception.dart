// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'custom_app_exception.freezed.dart';

@freezed
class CustomAppException with _$CustomAppException {
  const factory CustomAppException.entryNotFound() = EntryNotFound;
  const factory CustomAppException.timeRangesOverlap() = TimeRangesOverlap;
  const factory CustomAppException.projectNotFound() = ProjectNotFound;
  const factory CustomAppException.groupNotFound() = GroupNotFound;
  const factory CustomAppException.multipleTimerStarts() = MultipleTimerStarts;
  const factory CustomAppException.timerDataNotFound() = TimerDataNotFound;

  const factory CustomAppException.unexpected(String status) = Unexpected;
}

class CustomAppExceptionData {
  CustomAppExceptionData({
    required this.code,
    required this.message,
  });
  final String code;
  final String message;

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

extension CustomAppExceptioDetails on CustomAppException {
  CustomAppExceptionData message(AppLocalizations loc) {
    return when(
      entryNotFound: () => CustomAppExceptionData(
          code: '001', message: loc.entryNotFoundException),
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
      unexpected: (status) => CustomAppExceptionData(
        code: '500',
        message: 'Unexpected error: $status',
      ),
    );
  }
}
