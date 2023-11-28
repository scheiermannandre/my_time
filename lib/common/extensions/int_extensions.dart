import 'package:flutter/material.dart';

/// Extension for the [int] class, that gives access
extension IntExtension on int {
  /// Converts an [int] to a [TimeOfDay] object.
  TimeOfDay minutesToTimeOfDay() {
    return this == 0
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay(hour: this ~/ 60, minute: this % 60);
  }

  /// Returns the value of the specific bit at the position
  bool getBit(int position) {
    // Shifts the bit at the desired position to the least significant bit (LSB)
    // Then performs a bitwise AND operation with 1 to extract the bit value
    return ((this >> position) & 1) == 1;
  }

  /// Returns the sum of the bit values specified by the range
  int sumBitsInRange(int startBit, int endBit) {
    // Check if the range is valid
    if (startBit < 0 || endBit > 31 || startBit > endBit) {
      throw ArgumentError('Invalid bit range');
    }

    // Mask to extract bits within the specified range
    final mask = (1 << (endBit - startBit + 1)) - 1 << startBit;

    // Extract bits within the specified range and sum their values
    var sum = 0;
    for (var i = startBit; i <= endBit; i++) {
      // Check each bit using a mask and add the bit value to the sum
      if ((this & mask & (1 << i)) != 0) {
        sum++;
      }
    }
    return sum;
  }
}
