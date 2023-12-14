import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
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
    required this.sickDaysPayment,
    required this.publicHolidaysPayment,
    required this.vacationInfo,
    required this.timeManagement,
    required this.moneyManagement,
    required this.workplace,
    String? projectId,
  }) : id = projectId ?? const uuid.Uuid().v1();

  /// Factory method to create a `ProjectWithSettingsEntity` instance from
  /// the add project wizard.
  factory ProjectEntity.fromMap(
    Map<int, dynamic> projectMap,
  ) {
    return ProjectEntity(
      groupId: (projectMap[0] as GroupEntity).id,
      name: projectMap[1] as String,
      sickDaysPayment: projectMap[2] as PaymentStatus?,
      publicHolidaysPayment: projectMap[3] as PaymentStatus?,
      vacationInfo: projectMap[4] as VacationEntity?,
      timeManagement: projectMap[5] as ProjectTimeManagementEntity?,
      moneyManagement: projectMap[6] as ProjectMoneyManagementEntity?,
      workplace: projectMap[7] as Workplace?,
      isFavorite: false,
    );
  }

  /// A unique identifier for the project entity.
  final String id;

  /// The name or title of the project entity.
  final String name;

  /// The identifier of the group associated with this project entity.
  final String groupId;

  /// Represents whether the project entity is marked as a favorite or not.
  final bool isFavorite;

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

  /// Returns a copy of the current instance with the specified fields
  ProjectEntity copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
    PaymentStatus? sickDaysPayment,
    PaymentStatus? publicHolidaysPayment,
    VacationEntity? vacationInfo,
    ProjectTimeManagementEntity? timeManagement,
    ProjectMoneyManagementEntity? moneyManagement,
    Workplace? workplace,
  }) {
    return ProjectEntity(
      projectId: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      isFavorite: isFavorite ?? this.isFavorite,
      sickDaysPayment: sickDaysPayment ?? this.sickDaysPayment,
      publicHolidaysPayment:
          publicHolidaysPayment ?? this.publicHolidaysPayment,
      vacationInfo: vacationInfo ?? this.vacationInfo,
      timeManagement: timeManagement ?? this.timeManagement,
      moneyManagement: moneyManagement ?? this.moneyManagement,
      workplace: workplace ?? this.workplace,
    );
  }
}
