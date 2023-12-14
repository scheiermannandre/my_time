import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';

/// Represents the time management details for a project entity.
class ProjectTimeManagementEntity {
  /// Constructor for ProjectTimeManagementEntity.
  ProjectTimeManagementEntity({
    this.referencePeriod,
    this.workingHours,
  });

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
  ProjectTimeManagementEntity copyWith({
    ReferencePeriod? referencePeriod,
    int? workingHours,
  }) {
    return ProjectTimeManagementEntity(
      referencePeriod: referencePeriod ?? this.referencePeriod,
      workingHours: workingHours ?? this.workingHours,
    );
  }
}
