import 'package:my_time/features/5_project_history/5_project_history.dart';

abstract class ProjectHistoryRepository {
  Future<ProjectModel?> fetchProject(String projectId);
  Stream<List<TimeEntryModel>> streamProjectEntriesGroupedByMonth(
      String projectId);
}
