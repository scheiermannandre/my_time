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
}
