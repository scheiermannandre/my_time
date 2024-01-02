import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Enum representing different reference periods.
enum ReferencePeriod {
  /// Reference period is daily.
  daily,

  /// Reference period is weekly.
  weekly,

  /// Reference period is monthly.
  monthly,

  /// Reference period is annually.
  annually,
}

/// Extension for the ReferencePeriod enum.
extension ReferencePeriodExtension on ReferencePeriod {
  /// Get the label associated with the reference period.
  String label(BuildContext context) {
    switch (this) {
      case ReferencePeriod.daily:
        return context.loc.referencePeriodDaily; // Daily
      case ReferencePeriod.weekly:
        return context.loc.referencePeriodWeekly; // Weekly
      case ReferencePeriod.monthly:
        return context.loc.referencePeriodMonthly; // Monthly
      case ReferencePeriod.annually:
        return context.loc.referencePeriodYearly; // Annually
    }
  }
}
