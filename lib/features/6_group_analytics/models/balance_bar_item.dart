import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';

class BalanceBarItem {
  final String barDescriptionLabel;
  late final TimeOfDay desiredTime;
  late final TimeOfDay actualTime;
  late final String valueLabel;

  BalanceBarItem({
    required this.desiredTime,
    required this.actualTime,
    required this.barDescriptionLabel,
  }) : valueLabel = actualTime.toFormattedString();
}
