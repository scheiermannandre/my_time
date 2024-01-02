import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';
import 'package:my_time/domain/group_domain/models/enums/wokrplace.dart';
import 'package:my_time/domain/group_domain/models/group_entity.dart';
import 'package:my_time/domain/group_domain/models/project_money_management_entity.dart';
import 'package:my_time/domain/group_domain/models/project_time_management_entity.dart';
import 'package:my_time/domain/group_domain/models/vacation_entity.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Represents an entity for a project containing basic information such
/// as `id`, `name`, `groupId`, and whether it is marked as a favorite.
class NewProjectModel {
  /// Constructs a `ProjectEntity` instance with required parameters
  /// `name`, `groupId`, and `isFavorite`.
  NewProjectModel({
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
  factory NewProjectModel.fromWizard(
    Map<int, dynamic> projectMap,
  ) {
    return NewProjectModel(
      groupId: (projectMap[0] as NewGroupModel).id,
      name: projectMap[1] as String,
      sickDaysPayment: projectMap[2] as PaymentStatus?,
      publicHolidaysPayment: projectMap[3] as PaymentStatus?,
      vacationInfo: projectMap[4] as NewVacationModel?,
      timeManagement: projectMap[5] as NewProjectTimeManagementModel?,
      moneyManagement: projectMap[6] as NewProjectMoneyManagementModel?,
      workplace: projectMap[7] as Workplace?,
      isFavorite: false,
    );
  }

  /// Factory method to create a `ProjectModel`
  /// instance from a map representation.
  factory NewProjectModel.fromMap(Map<String, dynamic> map) {
    return NewProjectModel(
      projectId: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      isFavorite: map['isFavorite'] as bool,
      sickDaysPayment: map['sickDaysPayment'] != null
          ? PaymentStatus.values[map['sickDaysPayment'] as int]
          : null,
      publicHolidaysPayment: map['publicHolidaysPayment'] != null
          ? PaymentStatus.values[map['publicHolidaysPayment'] as int]
          : null,
      vacationInfo: map['vacationInfo'] != null
          ? NewVacationModel.fromMap(
              map['vacationInfo'] as Map<String, dynamic>,
            )
          : null,
      timeManagement: map['timeManagement'] != null
          ? NewProjectTimeManagementModel.fromMap(
              map['timeManagement'] as Map<String, dynamic>,
            )
          : null,
      moneyManagement: map['moneyManagement'] != null
          ? NewProjectMoneyManagementModel.fromMap(
              map['moneyManagement'] as Map<String, dynamic>,
            )
          : null,
      workplace: map['workplace'] != null
          ? Workplace.values[map['workplace'] as int]
          : null,
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
  final NewVacationModel? vacationInfo;

  /// Represents the time management settings for the project.
  final NewProjectTimeManagementModel? timeManagement;

  /// Represents the money management settings for the project.
  final NewProjectMoneyManagementModel? moneyManagement;

  /// Represents the workplace settings for the project.
  final Workplace? workplace;

  /// Returns a copy of the current instance with the specified fields
  NewProjectModel copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
    PaymentStatus? sickDaysPayment,
    PaymentStatus? publicHolidaysPayment,
    NewVacationModel? vacationInfo,
    NewProjectTimeManagementModel? timeManagement,
    NewProjectMoneyManagementModel? moneyManagement,
    Workplace? workplace,
  }) {
    return NewProjectModel(
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
