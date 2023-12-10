import 'package:my_time/common/common.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';

/// Represents a model for a project's money management.
class ProjectMoneyManagementModel {
  /// Constructs a `ProjectMoneyManagementModel` instance
  ProjectMoneyManagementModel({
    required this.paymentInterval,
    required this.payment,
    required this.currency,
  });

  /// Converts a `Map<String, dynamic>` instance to
  /// a `ProjectMoneyManagementModel` instance.
  factory ProjectMoneyManagementModel.fromMap(Map<String, dynamic> map) {
    return ProjectMoneyManagementModel(
      paymentInterval: map['paymentInterval'] as int?,
      payment: map['payment'] as double?,
      currency: map['currency'] as int?,
    );
  }

  /// Factory to create a ProjectMoneyManagementModel from an entity.
  factory ProjectMoneyManagementModel.fromEntity(
    ProjectMoneyManagementEntity entity,
  ) {
    return ProjectMoneyManagementModel(
      paymentInterval: entity.paymentInterval?.index,
      payment: entity.payment,
      currency: entity.currency?.index,
    );
  }

  /// Factory to create a ProjectMoneyManagementEntity
  /// from a ProjectMoneyManagementModel.
  ProjectMoneyManagementEntity toEntity() {
    return ProjectMoneyManagementEntity(
      paymentInterval: PaymentInterval.values
          .firstWhereOrNull((p0) => p0.index == paymentInterval),
      payment: payment,
      currency: Currency.values.firstWhereOrNull((p0) => p0.index == currency),
    );
  }

  /// The payment interval for the project.
  final int? paymentInterval;

  /// The payment amount for the project.
  final double? payment;

  /// The currency used for payments in the project.
  final int? currency;

  /// Converts a `ProjectMoneyManagementModel` instance
  /// to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'paymentInterval': paymentInterval,
      'payment': payment,
      'currency': currency,
    };
  }
}
