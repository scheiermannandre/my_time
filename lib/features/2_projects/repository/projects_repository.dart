import 'package:my_time/features/2_projects/2_projects.dart';

abstract class ProjectsRepository {
  Future<bool> addProject(ProjectModel project);
  Future<List<ProjectModel>> fetchProjectsByGroupId(String groupId);
  Stream<List<ProjectModel>> watchProjectsByGroupId(String groupId);

  Future<List<GroupModel>> fetchGroups();
  Future<GroupModel?> fetchGroup(String groupId);
  Future<bool> deleteGroup(String groupId);
}
