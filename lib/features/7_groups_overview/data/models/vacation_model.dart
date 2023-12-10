import 'package:my_time/common/common.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';

/// Represents a model for a project's vacation.
class VacationModel {
  /// Constructs a `VacationModel` instance
  VacationModel({required this.paymentStatus, required this.days});

  /// Converts a `Map<String, dynamic>` instance to a `VacationModel` instance.
  factory VacationModel.fromMap(Map<String, dynamic> map) {
    return VacationModel(
      paymentStatus: map['paymentStatus'] as int?,
      days: map['days'] as int?,
    );
  }

  /// Factory to create a VacationModel from an VacationEntity.
  factory VacationModel.fromEntity(VacationEntity entity) {
    return VacationModel(
      paymentStatus: entity.paymentStatus?.index,
      days: entity.days,
    );
  }

  /// Factory to create a VacationEntity from a VacationModel.
  VacationEntity toEntity() {
    return VacationEntity(
      paymentStatus: PaymentStatus.values
          .firstWhereOrNull((p0) => p0.index == paymentStatus),
      days: days,
    );
  }

  /// The payment status associated with the vacation.
  final int? paymentStatus;

  /// The number of days for the vacation.
  final int? days;

  /// Converts a `VacationModel` instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'paymentStatus': paymentStatus,
      'days': days,
    };
  }
}
