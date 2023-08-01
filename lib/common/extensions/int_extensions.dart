import 'package:flutter/material.dart';

/// Extension for the [int] class, that gives access
extension IntExtension on int {
  /// Converts an [int] to a [TimeOfDay] object.
  TimeOfDay minutesToTimeOfDay() {
    return this == 0
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay(hour: this ~/ 60, minute: this % 60);
  }
}
