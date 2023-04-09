import 'dart:io';

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedDateString(String languageCode) {
    final locale = Platform.localeName;
    return DateFormat.yMMMMEEEEd(locale).format(this);
  }

  String toFormattedWeekDayString(String languageCode) {
    final locale = Platform.localeName;
    return DateFormat.MMMMEEEEd(locale).format(this);
  }

  String toMonthAndYearString(String languageCode) {
    final locale = Platform.localeName;
    return DateFormat.yMMMM(locale).format(this);
  }

  String toFormattedTimeOfDayString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime yearAndMonth() {
    return DateTime(year, month);
  }
}
