import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';

/// Represents vacation-related information for an entity.
class NewVacationModel {
  /// Constructor for VacationEntity.
  NewVacationModel({this.paymentStatus, this.days});

  /// Converts a `Map<String, dynamic>` instance to a `VacationModel` instance.
  factory NewVacationModel.fromMap(Map<String, dynamic> map) {
    return NewVacationModel(
      paymentStatus: map['paymentStatus'] != null
          ? PaymentStatus.values[map['paymentStatus'] as int]
          : null,
      days: map['days'] as int?,
    );
  }

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

  /// Returns a copy of the `VacationEntity` instance
  NewVacationModel copyWith({
    PaymentStatus? paymentStatus,
    int? days,
  }) {
    return NewVacationModel(
      paymentStatus: paymentStatus ?? this.paymentStatus,
      days: days ?? this.days,
    );
  }
}
