import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

/// Represents a group entity.
class GroupEntity {
  /// Constructor for GroupEntity.
  GroupEntity({
    required this.id,
    required this.name,
    required this.projects,
  });

  /// Unique identifier for the group.
  final String id;

  /// Name of the group.
  final String name;

  /// List of projects associated with the group.
  final List<ProjectEntity> projects;
}
