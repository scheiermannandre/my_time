import 'package:my_time/features/2_projects/2_projects.dart';

/// Repository for the Projects feature.
abstract class ProjectsRepository {
  /// Will add a Project to the database.
  Future<bool> addProject(ProjectModel project);

  /// Will stream all Projects by their groupId from the database.
  Stream<List<ProjectModel>> streamProjectsByGroupId(String groupId);

  /// Will fetch all Groups from the database.
  Future<List<GroupModel>> fetchGroups();

  /// Will fetch a Group from the database.
  Future<GroupModel?> fetchGroup(String groupId);

  /// Will delete a Group from the database.
  Future<bool> deleteGroup(String groupId);
}
