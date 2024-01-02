import 'package:my_time/common/extensions/double_extensions.dart';
import 'package:my_time/domain/group_domain/models/enums/reference_period.dart';

/// Represents the time management details for a project entity.
class NewProjectTimeManagementModel {
  /// Constructor for ProjectTimeManagementEntity.
  NewProjectTimeManagementModel({
    this.referencePeriod,
    this.workingHours,
  });

  factory NewProjectTimeManagementModel.fromMap(Map<String, dynamic> map) {
    return NewProjectTimeManagementModel(
      referencePeriod: map['referencePeriod'] != null
          ? ReferencePeriod.values[map['referencePeriod'] as int]
          : null,
      workingHours: map['workingHours'] as int?,
    );
  }

  /// The reference period for time management in the project.
  final ReferencePeriod? referencePeriod;

  /// The number of working hours for the project.
  final int? workingHours;

  /// Converts a `ProjectTimeManagementEntity` instance
  /// to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'referencePeriod': referencePeriod?.index,
      'workingHours': workingHours,
    };
  }

  /// Returns a copy of the `ProjectTimeManagementEntity` instance
  NewProjectTimeManagementModel copyWith({
    ReferencePeriod? referencePeriod,
    int? workingHours,
  }) {
    return NewProjectTimeManagementModel(
      referencePeriod: referencePeriod ?? this.referencePeriod,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  double _calculateAbsolouteWorkingHours(ReferencePeriod neededPeriod) {
    if (workingHours == null) return 0;
    final tmpWorkingHours = workingHours!.toDouble();
    switch (neededPeriod) {
      case ReferencePeriod.daily:
        {
          switch (referencePeriod) {
            case ReferencePeriod.daily:
              return tmpWorkingHours;
            case ReferencePeriod.weekly:
              return tmpWorkingHours / 7;
            case ReferencePeriod.monthly:
              return tmpWorkingHours / 30;
            case ReferencePeriod.annually:
              return tmpWorkingHours / 365;
            default:
              return tmpWorkingHours;
          }
        }

      case ReferencePeriod.weekly:
        {
          switch (referencePeriod) {
            case ReferencePeriod.daily:
              return tmpWorkingHours * 7;
            case ReferencePeriod.weekly:
              return tmpWorkingHours;
            case ReferencePeriod.monthly:
              return tmpWorkingHours / 4;
            case ReferencePeriod.annually:
              return tmpWorkingHours / 52;
            default:
              return tmpWorkingHours;
          }
        }
      case ReferencePeriod.monthly:
        {
          switch (referencePeriod) {
            case ReferencePeriod.daily:
              return tmpWorkingHours * 30;
            case ReferencePeriod.weekly:
              return tmpWorkingHours * 4;
            case ReferencePeriod.monthly:
              return tmpWorkingHours;
            case ReferencePeriod.annually:
              return tmpWorkingHours / 12;
            default:
              return tmpWorkingHours;
          }
        }
      case ReferencePeriod.annually:
        {
          switch (referencePeriod) {
            case ReferencePeriod.daily:
              return tmpWorkingHours * 365;
            case ReferencePeriod.weekly:
              return tmpWorkingHours * 52;
            case ReferencePeriod.monthly:
              return tmpWorkingHours * 12;
            case ReferencePeriod.annually:
              return tmpWorkingHours;
            default:
              return tmpWorkingHours;
          }
        }
      default:
        return tmpWorkingHours;
    }
  }

  Duration get workingHoursPerDay =>
      _calculateAbsolouteWorkingHours(ReferencePeriod.daily)
          .convertToHHMMDuration();

  Duration get workingHoursPerWeek =>
      _calculateAbsolouteWorkingHours(ReferencePeriod.weekly)
          .convertToHHMMDuration();

  Duration get workingHoursPerMonth =>
      _calculateAbsolouteWorkingHours(ReferencePeriod.monthly)
          .convertToHHMMDuration();

  Duration get workingHoursPerYear =>
      _calculateAbsolouteWorkingHours(ReferencePeriod.annually)
          .convertToHHMMDuration();
}
