import 'package:flutter/material.dart';

/// Extension for the [TimeOfDay] class.
extension TimeOfDayExtension on TimeOfDay {
  /// Adds the given [TimeOfDay] to the current [TimeOfDay].
  TimeOfDay add(TimeOfDay time) {
    final additionalTime = Duration(hours: time.hour, minutes: time.minute);
    final previousTime = DateTime(0, 0, 0, hour, minute);
    return TimeOfDay.fromDateTime(previousTime.add(additionalTime));
  }

  /// Returns a formatted string using the HH:mm pattern.
  String toFormattedString() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Converts a [TimeOfDay] to a [Duration] object.
  Duration toDuration() {
    return Duration(hours: hour, minutes: minute);
  }

  /// Converts a [TimeOfDay] to minutes.
  int toMinutes() {
    return hour * 60 + minute;
  }
}
