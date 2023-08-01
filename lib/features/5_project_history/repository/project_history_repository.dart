import 'package:my_time/features/5_project_history/5_project_history.dart';

/// Repository for the project history feature.
abstract class ProjectHistoryRepository {
  /// Will fetch a project from the database by id.
  Future<ProjectModel?> fetchProject(String projectId);

  /// Will stream all TimeEntries from the database by project id.
  Stream<List<TimeEntryModel>> streamProjectEntries(String projectId);
}
