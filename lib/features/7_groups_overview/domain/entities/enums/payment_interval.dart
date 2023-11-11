import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Enum representing different payment intervals.
enum PaymentInterval {
  /// Payment made hourly.
  hourly,

  /// Payment made daily.
  daily,

  /// Payment made weekly.
  weekly,

  /// Payment made monthly.
  monthly,
}

/// Extension for the PaymentInterval enum.
extension PaymentIntervalExtension on PaymentInterval {
  /// Get the label associated with the payment interval.
  String label(BuildContext context) {
    switch (this) {
      case PaymentInterval.hourly:
        return context.loc.paymentIntervalHourly; // Hourly payment
      case PaymentInterval.daily:
        return context.loc.paymentIntervalDaily; // Daily payment
      case PaymentInterval.weekly:
        return context.loc.paymentIntervalWeekly; // Weekly payment
      case PaymentInterval.monthly:
        return context.loc.paymentIntervalMonthly; // Monthly payment
    }
  }
}
