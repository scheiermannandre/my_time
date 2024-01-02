import 'package:my_time/domain/group_domain/models/project_entity.dart';

/// Abstract class representing operations on projects.
abstract class ProjectRepository {
  /// Adds a project with settings specified by the [project] entity.
  Future<void> addProject(NewProjectModel project);

  /// Updates a project with settings specified by the [project] entity.
  Future<void> updateProject(NewProjectModel project);

  /// Streams a project specified by the [groupId] and [projectId].
  Stream<NewProjectModel> streamProject(
    String groupId,
    String projectId,
  );

  /// Fetches a project specified by the [groupId] and [projectId].
  Future<NewProjectModel> fetchProject(
    String groupId,
    String projectId,
  );
}
