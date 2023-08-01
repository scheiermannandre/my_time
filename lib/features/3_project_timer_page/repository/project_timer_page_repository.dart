import 'package:my_time/features/3_project_timer_page/domain/project_timer_model.dart';

/// Repository for the ProjectTimerPage.
abstract class ProjectTimerPageRepository {
  /// Will fetch the timer data for the project.
  Future<ProjectTimerModel?> fetchTimerData(String projectId);

  /// Will save the timer data for the project.
  Future<ProjectTimerModel> saveTimerData(ProjectTimerModel timerData);

  /// Will delete the timer data for the project.
  Future<ProjectTimerModel> deleteTimerData(
    ProjectTimerModel timerData,
    DateTime endTime,
  );

  /// Will update the timer data state.
  Future<ProjectTimerModel> updateTimerDataState(
    ProjectTimerModel timerData,
    DateTime stateChangeTime,
  );
}
