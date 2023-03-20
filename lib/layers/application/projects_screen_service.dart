import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/timer_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ProjectsScreenService {
  final Map<String, CustomTimer> timers = {};

  void startTimer(String projectId) {
    if (!timers.containsKey(projectId)) {
      timers[projectId] = CustomTimer();
    }
    timers[projectId]!.startTimer();
  }

  void stopTimer(String projectId) {
    if (timers.containsKey(projectId)) {
      timers[projectId]!.stopTimer();
    }
    //ToDo save Timer do DB
  }

  void pauseResumeTimer(String projectId) {
    if (timers.containsKey(projectId)) {
      timers[projectId]!.pauseResumeTimer();
    }
  }

  Stream<TimerData> watchTimerData(String projectId) async* {
    yield* Stream.periodic(const Duration(milliseconds: 1000), (index) {
      if (timers.containsKey(projectId)) {
        final data = timers[projectId]!.data;
        return data;
      }
      return TimerData(duration: const Duration(), state: TimerState.off);
    });
  }
}

final projectsScreenServiceProvider = Provider<ProjectsScreenService>((ref) {
  return ProjectsScreenService();
});
