import 'dart:io';

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedDateString(String languageCode) {
    final locale = Platform.localeName;
    final format = DateFormat('EEE, MMM d, y', locale);
    return format.format(this);
  }

  String toFormattedWeekDayString(String languageCode) {
    final locale = Platform.localeName;
    final format = DateFormat('EEEE, d', locale);
    return format.format(this);
  }

  String toMonthAndYearString(String languageCode) {
    final locale = Platform.localeName;
    final format = DateFormat('MMMM y', locale);
    return format.format(this);
  }

  String toFormattedTimeOfDayString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime yearAndMonth() {
    return DateTime(year, month);
  }
}
