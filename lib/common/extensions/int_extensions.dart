import 'package:flutter/material.dart';

extension IntExtension on int {
  TimeOfDay minutesToTimeOfDay() {
    return this == 0
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay(hour: this ~/ 60, minute: this % 60);
  }
}
