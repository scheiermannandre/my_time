import 'package:flutter/material.dart';

extension StringExtension on String {
  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
        hour: int.parse(split(":")[0]), minute: int.parse(split(":")[1]));
  }
}
