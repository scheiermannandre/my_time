import 'dart:io';
import 'package:intl/intl.dart';

/// Extension for the [DateTime] class.
extension DateTimeExtension on DateTime {
  /// Returns the date as a formatted string using the yMMMMEEEEd pattern.
  String toFormattedDateString({String? languageCode}) {
    final locale = Platform.localeName;
    return DateFormat.yMMMMEEEEd(locale).format(this);
  }

  /// Returns the date as a formatted string using the MMMMEEEEd pattern.
  String toFormattedWeekDayString({String? languageCode}) {
    final locale = Platform.localeName;
    return DateFormat.MMMMEEEEd(locale).format(this);
  }

  /// Returns the date as a formatted string using the yMMMM pattern.
  String toMonthAndYearString({String? languageCode}) {
    final locale = Platform.localeName;
    return DateFormat.yMMMM(locale).format(this);
  }

  /// Returns the date as a formatted string using the yMMMM pattern.
  String toShortDateString() {
    final locale = Platform.localeName;
    return DateFormat.yMd(locale).format(this);
  }

  /// Returns a formatted string using the HH:mm pattern.
  String toFormattedTimeOfDayString() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Returns a DateTime only containing the year and month as the
  /// current DateTime.
  DateTime yearAndMonth() {
    return DateTime(year, month);
  }
}
