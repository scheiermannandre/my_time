import 'package:flutter/material.dart';

/// Duration extension
extension DurationExtension on Duration {
  /// Returns a formatted string using the HH:mm pattern.
  String toFormattedString() {
    String sign = '';
    if (inMinutes < 0) {
      sign = '-';
    }
    final absDuration = Duration(minutes: inMinutes.abs());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(absDuration.inMinutes.remainder(60));
    return '$sign${twoDigits(absDuration.inHours)}:$twoDigitMinutes';
  }

  /// Returns a Duration from a string that prevously was a duration.
  static Duration parseDuration(String durationStr) {
    // hh:mm:ss.ffffff
    final componentsStr = durationStr.split(':');
    final sAndMs = componentsStr.last.split('.');
    componentsStr
      ..removeLast()
      ..addAll(sAndMs);
    final components = componentsStr.map(int.parse).toList();
    final duration = Duration(
      hours: components[0],
      minutes: components[1],
      seconds: components[2],
      microseconds: components[3],
    );
    return duration;
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: inHours,
      minute: inMinutes.remainder(60),
    );
  }

  double toHours() {
    return inMinutes / 60;
  }
}
