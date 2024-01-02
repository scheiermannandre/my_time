import 'package:my_time/domain/group_domain/models/enums/currency.dart';
import 'package:my_time/domain/group_domain/models/enums/payment_interval.dart';

/// Represents the money management details for a project entity.
class NewProjectMoneyManagementModel {
  /// Constructor for ProjectMoneyManagementEntity.
  NewProjectMoneyManagementModel({
    this.currency,
    this.paymentInterval,
    this.payment,
  });

  factory NewProjectMoneyManagementModel.fromMap(Map<String, dynamic> map) {
    return NewProjectMoneyManagementModel(
      paymentInterval: map['paymentInterval'] != null
          ? PaymentInterval.values[map['paymentInterval'] as int]
          : null,
      payment: map['payment'] as double?,
      currency: map['currency'] != null
          ? Currency.values[map['currency'] as int]
          : null,
    );
  }

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

  /// Returns a copy of the `ProjectMoneyManagementEntity` instance
  NewProjectMoneyManagementModel copyWith({
    PaymentInterval? paymentInterval,
    double? payment,
    Currency? currency,
  }) {
    return NewProjectMoneyManagementModel(
      paymentInterval: paymentInterval ?? this.paymentInterval,
      payment: payment ?? this.payment,
      currency: currency ?? this.currency,
    );
  }
}
