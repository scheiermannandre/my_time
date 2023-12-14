import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

/// Abstract class representing operations on projects.
abstract class ProjectRepository {
  /// Adds a project with settings specified by the [project] entity.
  Future<void> addProject(ProjectEntity project);

  /// Updates a project with settings specified by the [project] entity.
  Future<void> updateProject(ProjectEntity project);

  /// Streams a project specified by the [groupId] and [projectId].
  Stream<ProjectEntity> streamProject(
    String groupId,
    String projectId,
  );

  /// Fetches a project specified by the [groupId] and [projectId].
  Future<ProjectEntity> fetchProject(
    String groupId,
    String projectId,
  );
}
