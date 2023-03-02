import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add(TimeOfDay time) {
    Duration additionalTime = Duration(hours: time.hour, minutes: time.minute);
    DateTime previousTime = DateTime(0, 0, 0, hour, minute);
    return TimeOfDay.fromDateTime(previousTime.add(additionalTime));
  }

  String toFormattedString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Duration toDuration() {
    return Duration(hours: hour, minutes: minute);
  }
}
