import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

/// An immutable class representing a project with its settings.
@immutable
class ProjectWithSettingsModel {
  /// Constructs a [ProjectWithSettingsModel] with required properties.
  const ProjectWithSettingsModel({
    required this.id,
    required this.name,
    required this.groupId,
    required this.isFavorite,
    required this.sickDaysPayment,
    required this.publicHolidaysPayment,
    required this.vacationInfoPayment,
    required this.vacationInfoDays,
    required this.timeManagementReferencePeriod,
    required this.timeManagementWorkingHours,
    required this.moneyManagementPaymentInterval,
    this.moneyManagementPayment,
    this.moneyManagementCurrency,
    this.workplace,
  });

  /// Constructs a [ProjectWithSettingsModel] from a map.
  factory ProjectWithSettingsModel.fromMap(Map<String, dynamic> map) {
    return ProjectWithSettingsModel(
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      isFavorite: map['isFavorite'] as bool,
      sickDaysPayment: map['sickDaysPayment'] as int?,
      publicHolidaysPayment: map['publicHolidaysPayment'] as int?,
      vacationInfoPayment: map['vacationInfoPayment'] as int?,
      vacationInfoDays: map['vacationInfoDays'] as int?,
      timeManagementReferencePeriod:
          map['timeManagementReferencePeriod'] as int?,
      timeManagementWorkingHours:
          map['timeManagementReferenceworkingHours'] as int?,
      moneyManagementPaymentInterval:
          map['moneyManagementPaymentInterval'] as int?,
      moneyManagementPayment: map['moneyManagementPayment'] as double?,
      moneyManagementCurrency: map['moneyManagementCurrency'] as int?,
      workplace: map['workplace'] as int?,
    );
  }

  /// Constructs a [ProjectWithSettingsModel] from JSON string.
  factory ProjectWithSettingsModel.fromJson(String source) =>
      ProjectWithSettingsModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  /// Constructs a [ProjectWithSettingsModel] from an entity.
  factory ProjectWithSettingsModel.fromEntity(
    ProjectWithSettingsEntity entity,
  ) {
    return ProjectWithSettingsModel(
      id: entity.id,
      name: entity.name,
      groupId: entity.groupId,
      isFavorite: entity.isFavorite,
      sickDaysPayment: entity.sickDaysPayment?.index,
      publicHolidaysPayment: entity.publicHolidaysPayment?.index,
      vacationInfoPayment: entity.vacationInfo?.paymentStatus?.index,
      vacationInfoDays: entity.vacationInfo?.days,
      timeManagementReferencePeriod:
          entity.timeManagement?.referencePeriod?.index,
      timeManagementWorkingHours: entity.timeManagement?.workingHours,
      moneyManagementPaymentInterval:
          entity.moneyManagement?.paymentInterval?.index,
      moneyManagementPayment: entity.moneyManagement?.payment,
      moneyManagementCurrency: entity.moneyManagement?.currency?.index,
      workplace: entity.workplace?.index,
    );
  }

  /// The unique identifier of the project.
  final String id;

  /// The name of the project.
  final String name;

  /// The identifier of the group to which the project belongs.
  final String groupId;

  /// Indicates whether the project is marked as favorite.
  final bool isFavorite;

  /// Payment for sick days associated with the project.
  final int? sickDaysPayment;

  /// Payment for public holidays associated with the project.
  final int? publicHolidaysPayment;

  /// Payment for vacation information associated with the project.
  final int? vacationInfoPayment;

  /// Number of days for vacation information associated with the project.
  final int? vacationInfoDays;

  /// Reference period for time management associated with the project.
  final int? timeManagementReferencePeriod;

  /// Working hours for time management associated with the project.
  final int? timeManagementWorkingHours;

  /// Payment interval for money management associated with the project.
  final int? moneyManagementPaymentInterval;

  /// Payment amount for money management associated with the project.
  final double? moneyManagementPayment;

  /// Currency for money management associated with the project.
  final int? moneyManagementCurrency;

  /// Workplace information associated with the project.
  final int? workplace;

  /// Creates a copy of this model with optional new values.
  ProjectWithSettingsModel copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
    int? sickDaysPayment,
    int? publicHolidaysPayment,
    int? vacationInfoPayment,
    int? vacationInfoDays,
    int? timeManagementReferencePeriod,
    int? timeManagementReferenceworkingHours,
    int? moneyManagementPaymentInterval,
    double? moneyManagementPayment,
    int? moneyManagementCurrency,
    int? workplace,
  }) {
    return ProjectWithSettingsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      isFavorite: isFavorite ?? this.isFavorite,
      sickDaysPayment: sickDaysPayment ?? this.sickDaysPayment,
      publicHolidaysPayment:
          publicHolidaysPayment ?? this.publicHolidaysPayment,
      vacationInfoPayment: vacationInfoPayment ?? this.vacationInfoPayment,
      vacationInfoDays: vacationInfoDays ?? this.vacationInfoDays,
      timeManagementReferencePeriod:
          timeManagementReferencePeriod ?? this.timeManagementReferencePeriod,
      timeManagementWorkingHours:
          timeManagementReferenceworkingHours ?? timeManagementWorkingHours,
      moneyManagementPaymentInterval:
          moneyManagementPaymentInterval ?? this.moneyManagementPaymentInterval,
      moneyManagementPayment:
          moneyManagementPayment ?? this.moneyManagementPayment,
      moneyManagementCurrency:
          moneyManagementCurrency ?? this.moneyManagementCurrency,
      workplace: workplace ?? this.workplace,
    );
  }

  /// Converts the model to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'groupId': groupId,
      'isFavorite': isFavorite,
      'sickDaysPayment': sickDaysPayment,
      'publicHolidaysPayment': publicHolidaysPayment,
      'vacationInfoPayment': vacationInfoPayment,
      'vacationInfoDays': vacationInfoDays,
      'timeManagementReferencePeriod': timeManagementReferencePeriod,
      'timeManagementReferenceworkingHours': timeManagementWorkingHours,
      'moneyManagementPaymentInterval': moneyManagementPaymentInterval,
      'moneyManagementPayment': moneyManagementPayment,
      'moneyManagementCurrency': moneyManagementCurrency,
      'workplace': workplace,
    };
  }

  /// Converts the model to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''
      ProjectWithSettingsModel(
      id: $id, 
      name: $name, 
      groupId: $groupId, 
      isFavorite: $isFavorite, 
      sickDaysPayment: $sickDaysPayment, 
      publicHolidaysPayment: $publicHolidaysPayment, 
      vacationInfoPayment: $vacationInfoPayment, 
      vacationInfoDays: $vacationInfoDays, 
      timeManagementReferencePeriod: $timeManagementReferencePeriod, 
      timeManagementReferenceworkingHours: $timeManagementWorkingHours, 
      moneyManagementPaymentInterval: $moneyManagementPaymentInterval, 
      moneyManagementPayment: $moneyManagementPayment, 
      moneyManagementCurrency: $moneyManagementCurrency, 
      workplace: $workplace
    )''';
  }

  @override
  bool operator ==(covariant ProjectWithSettingsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.groupId == groupId &&
        other.isFavorite == isFavorite &&
        other.sickDaysPayment == sickDaysPayment &&
        other.publicHolidaysPayment == publicHolidaysPayment &&
        other.vacationInfoPayment == vacationInfoPayment &&
        other.vacationInfoDays == vacationInfoDays &&
        other.timeManagementReferencePeriod == timeManagementReferencePeriod &&
        other.timeManagementWorkingHours == timeManagementWorkingHours &&
        other.moneyManagementPaymentInterval ==
            moneyManagementPaymentInterval &&
        other.moneyManagementPayment == moneyManagementPayment &&
        other.moneyManagementCurrency == moneyManagementCurrency &&
        other.workplace == workplace;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        groupId.hashCode ^
        isFavorite.hashCode ^
        sickDaysPayment.hashCode ^
        publicHolidaysPayment.hashCode ^
        vacationInfoPayment.hashCode ^
        vacationInfoDays.hashCode ^
        timeManagementReferencePeriod.hashCode ^
        timeManagementWorkingHours.hashCode ^
        moneyManagementPaymentInterval.hashCode ^
        moneyManagementPayment.hashCode ^
        moneyManagementCurrency.hashCode ^
        workplace.hashCode;
  }
}
