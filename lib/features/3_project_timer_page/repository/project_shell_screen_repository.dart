import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// Repository for the ProjectShellScreen.
abstract class ProjectShellScreenRepository {
  /// Will delete the project with the given [projectId].
  Future<bool> deleteProject(String projectId);

  /// Will update the [ProjectModel.isMarkedAsFavourite] state of the project
  /// with the given [projectId].
  Future<void> updateIsFavouriteState(
    String projectId, {
    required bool isFavourite,
  });

  /// Will fetch the project with the given [projectId].
  Future<ProjectModel?> fetchProject(String projectId);

  /// Will stream the project with the given [projectId].
  Stream<ProjectModel> streamProject(String projectId);
}
