import 'package:my_time/layers/interface/dto/project_dto.dart';

abstract class ProjectsRepository {
  Future<List<ProjectDTO>> fetchFavouriteProjects();
  Future<bool> addProject(ProjectDTO project);
  Future<List<ProjectDTO>> fetchProjectsByGroupId(String groupId);
  Stream<List<ProjectDTO>> watchProjectsByGroupId(String groupId);
  Future<bool> deleteProject(ProjectDTO project);
  Future<void> updateIsFavouriteState(ProjectDTO project);
  Future<ProjectDTO?> fetchProject(String projectId);
}
