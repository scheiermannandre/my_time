import 'package:my_time/common/common.dart';
import 'package:my_time/domain/group_domain/models/enums/reference_period.dart';
import 'package:my_time/domain/group_domain/models/project_time_management_entity.dart';

/// Represents a model for a project's time management.
class ProjectTimeManagementModel {
  /// Constructs a `ProjectTimeManagementModel` instance
  ProjectTimeManagementModel({
    required this.referencePeriod,
    required this.workingHours,
  });

  /// Converts a `Map<String, dynamic>` instance to
  /// a `ProjectTimeManagementModel` instance.
  factory ProjectTimeManagementModel.fromMap(Map<String, dynamic> map) {
    return ProjectTimeManagementModel(
      referencePeriod: map['referencePeriod'] as int?,
      workingHours: map['workingHours'] as int?,
    );
  }

  /// Factory to create a ProjectTimeManagementModel from an entity.
  factory ProjectTimeManagementModel.fromEntity(
    NewProjectTimeManagementModel entity,
  ) {
    return ProjectTimeManagementModel(
      referencePeriod: entity.referencePeriod?.index,
      workingHours: entity.workingHours,
    );
  }

  /// Factory to create a ProjectTimeManagementEntity
  /// from a ProjectTimeManagementModel.
  NewProjectTimeManagementModel toEntity() {
    return NewProjectTimeManagementModel(
      referencePeriod: ReferencePeriod.values
          .firstWhereOrNull((p0) => p0.index == referencePeriod),
      workingHours: workingHours,
    );
  }

  /// The reference period for time management in the project.
  final int? referencePeriod;

  /// The number of working hours for the project.
  final int? workingHours;

  /// Converts a `ProjectTimeManagementModel` instance to
  /// a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'referencePeriod': referencePeriod,
      'workingHours': workingHours,
    };
  }
}
