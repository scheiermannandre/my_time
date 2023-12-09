/// Abstract class representing operations on projects.
// ignore: one_member_abstracts
abstract class ProjectRepository {
  /// Adds a project with settings specified by the [project] entity.
  Future<void> addProject(
    String groupId,
    String projectId,
    Map<String, dynamic> project,
  );
}
