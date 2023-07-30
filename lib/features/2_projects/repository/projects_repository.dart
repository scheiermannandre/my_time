import 'package:my_time/features/2_projects/2_projects.dart';

abstract class ProjectsRepository {
  Future<bool> addProject(ProjectModel project);
  Stream<List<ProjectModel>> streamProjectsByGroupId(String groupId);
  Future<List<GroupModel>> fetchGroups();
  Future<GroupModel?> fetchGroup(String groupId);
  Future<bool> deleteGroup(String groupId);
}
