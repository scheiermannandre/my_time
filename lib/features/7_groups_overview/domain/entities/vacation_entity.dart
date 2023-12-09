import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';

/// Represents vacation-related information for an entity.
class VacationEntity {
  /// Constructor for VacationEntity.
  VacationEntity({this.paymentStatus, this.days});

  /// The payment status associated with the vacation.
  final PaymentStatus? paymentStatus;

  /// The number of days for the vacation.
  final int? days;

  /// Converts a `VacationEntity` instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'paymentStatus': paymentStatus?.index,
      'days': days,
    };
  }
}
