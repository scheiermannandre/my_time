import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Represents an entity for a project containing basic information such
/// as `id`, `name`, `groupId`, and whether it is marked as a favorite.
class ProjectEntity {
  /// Constructs a `ProjectEntity` instance with required parameters
  /// `name`, `groupId`, and `isFavorite`.
  ProjectEntity({
    required this.name,
    required this.groupId,
    required this.isFavorite,
  }) : id = const uuid.Uuid().v1();

  /// A unique identifier for the project entity.
  final String id;

  /// The name or title of the project entity.
  final String name;

  /// The identifier of the group associated with this project entity.
  final String groupId;

  /// Represents whether the project entity is marked as a favorite or not.
  final bool isFavorite;
}

/// Represents an extension of `ProjectEntity` with additional settings
/// for a project.
class ProjectWithSettingsEntity extends ProjectEntity {
  /// Constructs a `ProjectWithSettingsEntity` instance with additional
  /// settings and inherits properties from `ProjectEntity`.
  ProjectWithSettingsEntity({
    required super.name,
    required super.groupId,
    required this.sickDaysPayment,
    required this.publicHolidaysPayment,
    required this.vacationInfo,
    required this.timeManagement,
    required this.moneyManagement,
    required this.workplace,
  }) : super(isFavorite: false);

  /// Represents the payment status for sick days.
  final PaymentStatus? sickDaysPayment;

  /// Represents the payment status for public holidays.
  final PaymentStatus? publicHolidaysPayment;

  /// Represents the vacation information for the project.
  final VacationEntity? vacationInfo;

  /// Represents the time management settings for the project.
  final ProjectTimeManagementEntity? timeManagement;

  /// Represents the money management settings for the project.
  final ProjectMoneyManagementEntity? moneyManagement;

  /// Represents the workplace settings for the project.
  final Workplace? workplace;

  /// Provides a string representation of the
  /// `ProjectWithSettingsEntity` instance.
  @override
  String toString() {
    return '''ProjectWithSettingsEntity(sickDaysPayment: $sickDaysPayment, publicHolidaysPayment: $publicHolidaysPayment, vacationInfo: $vacationInfo, timeManagement: $timeManagement, moneyManagement: $moneyManagement, workplace: $workplace)''';
  }
}
