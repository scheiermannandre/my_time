import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Enum representing different payment statuses.
enum PaymentStatus {
  /// Payment has been made.
  paid,

  /// Payment is unpaid.
  unpaid,
}

/// Extension for the PaymentStatus enum.
extension PaymentStatusExtension on PaymentStatus {
  /// Get the label associated with the payment status.
  String label(BuildContext context) {
    switch (this) {
      case PaymentStatus.paid:
        return context.loc.paymentStatusPaid; // Paid
      case PaymentStatus.unpaid:
        return context.loc.paymentStatusUnpaid; // Unpaid
    }
  }
}
