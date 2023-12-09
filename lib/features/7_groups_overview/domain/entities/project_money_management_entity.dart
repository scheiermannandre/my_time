import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';

/// Represents the money management details for a project entity.
class ProjectMoneyManagementEntity {
  /// Constructor for ProjectMoneyManagementEntity.
  ProjectMoneyManagementEntity({
    this.currency,
    this.paymentInterval,
    this.payment,
  });

  /// The payment interval for the project.
  final PaymentInterval? paymentInterval;

  /// The payment amount for the project.
  final double? payment;

  /// The currency used for payments in the project.
  final Currency? currency;

  /// Converts a `ProjectMoneyManagementEntity` instance
  /// to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'paymentInterval': paymentInterval?.index,
      'payment': payment,
      'currency': currency?.index,
    };
  }
}
