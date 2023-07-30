import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

abstract class ProjectShellScreenRepository {
  Future<bool> deleteProject(String projectId);
  Future<void> updateIsFavouriteState(String projectId, bool isFavourite);
  Future<ProjectModel?> fetchProject(String projectId);
  Stream<ProjectModel> streamProject(String projectId);
}
