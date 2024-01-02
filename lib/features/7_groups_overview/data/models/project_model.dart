import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/domain/group_domain/models/enums/payment_status.dart';
import 'package:my_time/domain/group_domain/models/enums/wokrplace.dart';
import 'package:my_time/domain/group_domain/models/project_entity.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_money_management_model.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_time_management_model.dart';
import 'package:my_time/features/7_groups_overview/data/models/vacation_model.dart';

@immutable

/// Represents a model for a project that contains information such as
/// its `id`, `name`, `groupId`, and whether it is marked as a favorite.
class ProjectModel {
  /// Constructs a `ProjectModel` instance with required
  /// parameters `id`, `name`, `groupId`, and `isFavorite`.
  const ProjectModel({
    required this.id,
    required this.name,
    required this.groupId,
    required this.isFavorite,
    required this.sickDaysPayment,
    required this.publicHolidaysPayment,
    required this.vacationInfo,
    required this.timeManagement,
    required this.moneyManagement,
    required this.workplace,
  });

  /// Factory method to create a `ProjectModel` instance from a `ProjectEntity`.
  factory ProjectModel.fromEntity(NewProjectModel entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      groupId: entity.groupId,
      isFavorite: entity.isFavorite,
      sickDaysPayment: entity.sickDaysPayment?.index,
      publicHolidaysPayment: entity.publicHolidaysPayment?.index,
      vacationInfo: entity.vacationInfo != null
          ? VacationModel.fromEntity(entity.vacationInfo!)
          : null,
      timeManagement: entity.timeManagement != null
          ? ProjectTimeManagementModel.fromEntity(entity.timeManagement!)
          : null,
      moneyManagement: entity.moneyManagement != null
          ? ProjectMoneyManagementModel.fromEntity(entity.moneyManagement!)
          : null,
      workplace: entity.workplace?.index,
    );
  }

  /// Factory method to create a `ProjectModel`
  /// instance from a map representation.
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      isFavorite: map['isFavorite'] as bool,
      sickDaysPayment:
          map['sickDaysPayment'] != null ? map['sickDaysPayment'] as int : null,
      publicHolidaysPayment: map['publicHolidaysPayment'] != null
          ? map['publicHolidaysPayment'] as int
          : null,
      vacationInfo: map['vacationInfo'] != null
          ? VacationModel.fromMap(map['vacationInfo'] as Map<String, dynamic>)
          : null,
      timeManagement: map['timeManagement'] != null
          ? ProjectTimeManagementModel.fromMap(
              map['timeManagement'] as Map<String, dynamic>,
            )
          : null,
      moneyManagement: map['moneyManagement'] != null
          ? ProjectMoneyManagementModel.fromMap(
              map['moneyManagement'] as Map<String, dynamic>,
            )
          : null,
      workplace: map['workplace'] != null ? map['workplace'] as int : null,
    );
  }

  /// Factory method to create a `ProjectModel` instance from a JSON `String`.
  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// A unique identifier for the project.
  final String id;

  /// The name or title of the project.
  final String name;

  /// The identifier of the group associated with this project.
  final String groupId;

  /// Represents whether the project is marked as a favorite or not.
  final bool isFavorite;

  /// Represents the payment status for sick days.
  final int? sickDaysPayment;

  /// Represents the payment status for public holidays.
  final int? publicHolidaysPayment;

  /// Represents the vacation information for the project.
  final VacationModel? vacationInfo;

  /// Represents the time management settings for the project.
  final ProjectTimeManagementModel? timeManagement;

  /// Represents the money management settings for the project.
  final ProjectMoneyManagementModel? moneyManagement;

  /// Represents the workplace settings for the project.
  final int? workplace;

  /// Returns a new `ProjectModel` instance with updated
  /// values for `id`, `name`, `groupId`, or `isFavorite`.
  ProjectModel copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
    int? sickDaysPayment,
    int? publicHolidaysPayment,
    VacationModel? vacationInfo,
    ProjectTimeManagementModel? timeManagement,
    ProjectMoneyManagementModel? moneyManagement,
    int? workplace,
  }) {
    return ProjectModel(
      id: id ?? this.id,
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

  /// Converts the `ProjectModel` object to a `ProjectEntity` object.
  NewProjectModel toEntity() {
    return NewProjectModel(
      projectId: id,
      name: name,
      groupId: groupId,
      isFavorite: isFavorite,
      sickDaysPayment: PaymentStatus.values
          .firstWhereOrNull((p0) => p0.index == sickDaysPayment),
      publicHolidaysPayment: PaymentStatus.values
          .firstWhereOrNull((p0) => p0.index == publicHolidaysPayment),
      vacationInfo: vacationInfo?.toEntity(),
      timeManagement: timeManagement?.toEntity(),
      moneyManagement: moneyManagement?.toEntity(),
      workplace:
          Workplace.values.firstWhereOrNull((p0) => p0.index == workplace),
    );
  }

  /// Converts the `ProjectModel` object to
  /// a `Map<String, dynamic>` representation.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'groupId': groupId,
      'isFavorite': isFavorite,
      'sickDaysPayment': sickDaysPayment,
      'publicHolidaysPayment': publicHolidaysPayment,
      'vacationInfo': vacationInfo?.toMap(),
      'timeManagement': timeManagement?.toMap(),
      'moneyManagement': moneyManagement?.toMap(),
      'workplace': workplace,
    };
  }

  /// Converts the `ProjectModel` object to a JSON `String`.
  String toJson() => json.encode(toMap());

  /// Provides a string representation of the `ProjectModel` instance.
  @override
  String toString() {
    return '''ProjectModel(id: $id, name: $name, groupId: $groupId, isFavorite: $isFavorite, sickDaysPayment: $sickDaysPayment, publicHolidaysPayment: $publicHolidaysPayment, vacationInfo: $vacationInfo, timeManagement: $timeManagement, moneyManagement: $moneyManagement, workplace: $workplace)''';
  }

  /// Overrides the equality operator to compare two `ProjectModel`
  /// instances based on their `id`, `name`, `groupId`, and `isFavorite`.
  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.groupId == groupId &&
        other.isFavorite == isFavorite &&
        other.sickDaysPayment == sickDaysPayment &&
        other.publicHolidaysPayment == publicHolidaysPayment &&
        other.vacationInfo == vacationInfo &&
        other.timeManagement == timeManagement &&
        other.moneyManagement == moneyManagement &&
        other.workplace == workplace;
  }

  /// Generates a hash code based on the
  /// `id`, `name`, `groupId`, and `isFavorite`.
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        groupId.hashCode ^
        isFavorite.hashCode ^
        sickDaysPayment.hashCode ^
        publicHolidaysPayment.hashCode ^
        vacationInfo.hashCode ^
        timeManagement.hashCode ^
        moneyManagement.hashCode ^
        workplace.hashCode;
  }
}
