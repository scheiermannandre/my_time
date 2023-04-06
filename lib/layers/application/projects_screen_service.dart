import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/data/time_entries_repository.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/timer_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ProjectsScreenService {
  ProjectsScreenService({required this.ref});

  final ProviderRef ref;

  final Map<String, CustomTimer> timers = {};

  void startTimer(String projectId) {
    if (!timers.containsKey(projectId)) {
      timers[projectId] = CustomTimer();
    }
    timers[projectId]!.startTimer();
  }

  Future<TimeEntryDTO?> stopTimer(String projectId) async {
    if (!timers.containsKey(projectId)) {
      return null;
    }
    TimerData data = timers[projectId]!.stopTimer();
    TimeEntryDTO entry = TimeEntryDTO(
      projectId: projectId,
      startTime: data.startTime,
      endTime: data.endTime,
      totalTime: data.duration,
      breakTime: Duration.zero,
      description: "",
    );
    if (!await ref.read(timeEntriesRepositoryProvider).saveTimeEntry(entry)) {
      return null;
    }
    return entry;
  }

  void pauseResumeTimer(String projectId) {
    if (timers.containsKey(projectId)) {
      timers[projectId]!.pauseResumeTimer();
    }
  }

  Stream<TimerData> watchTimerData(String projectId) async* {
    yield* Stream.periodic(const Duration(milliseconds: 500), (index) {
      if (timers.containsKey(projectId)) {
        final data = timers[projectId]!.getData();
        return data;
      }
      return TimerData.defaultFactory();
    });
  }

  Stream<List<List<TimeEntryDTO>>?> watchAllEntriesGroupedByMonth(
      String projectId) async* {
    final timeEntriesRepository = ref.read(timeEntriesRepositoryProvider);

    yield* Stream.fromFuture(
        timeEntriesRepository.getAllProjectEntriesGroupedByMonth(projectId));
  }

  Future<bool> deleteProject(ProjectDTO project) async {
    return await ref.read(projectsRepositoryProvider).deleteProject(project);
  }
}

final projectsScreenServiceProvider = Provider<ProjectsScreenService>((ref) {
  return ProjectsScreenService(ref: ref);
});
