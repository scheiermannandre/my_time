import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';

/// Holds the data for the BalanceBar.
class BalanceBarItem {
  /// Creates a BalanceBarItem.
  BalanceBarItem({
    required this.desiredTime,
    required this.actualTime,
    required this.barDescriptionLabel,
  }) : valueLabel = actualTime.toFormattedString();

  /// Description of the bar.
  final String barDescriptionLabel;

  /// The desired time.
  late final TimeOfDay desiredTime;

  /// The actual time.
  late final TimeOfDay actualTime;

  /// The value label.
  late final String valueLabel;
}
