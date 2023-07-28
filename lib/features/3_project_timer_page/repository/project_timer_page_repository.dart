import 'package:my_time/features/3_project_timer_page/domain/project_timer_model.dart';

abstract class ProjectTimerPageRepository {
  Future<ProjectTimerModel?> fetchTimerData(String projectId);
  Future<ProjectTimerModel> saveTimerData(ProjectTimerModel timerData);
  Future<ProjectTimerModel> deleteTimerData(
      ProjectTimerModel timerData, DateTime endTime);
  Future<ProjectTimerModel> updateTimerDataState(
      ProjectTimerModel timerData, DateTime stateChangeTime);
}
