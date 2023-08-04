import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_timer_page_controller.g.dart';

/// State of the ProjectTimerShellPage.
class ProjectTimerPageState {
  /// Creates a [ProjectTimerPageState].
  ProjectTimerPageState({required this.timerData, required this.duration})
      : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  ProjectTimerPageState._private({
    required this.timerData,
    required this.duration,
    required this.refreshIndicatorKey,
  });

  /// The [ProjectTimerModel] of the page.
  final ProjectTimerModel? timerData;

  /// The current duration of the timer.
  final Duration duration;

  /// The key of the [RefreshIndicator].
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  /// Copy Method, so that the [ProjectTimerPageState] can be updated and still
  /// be immutable.
  ProjectTimerPageState copyWith({
    ProjectTimerModel? timerData,
    Duration? duration,
  }) {
    return ProjectTimerPageState._private(
      timerData: timerData ?? this.timerData,
      duration: duration ?? this.duration,
      refreshIndicatorKey: refreshIndicatorKey,
    );
  }
}

/// Controller for the ProjectTimerShellPage.
@riverpod
class ProjectTimerShellPageController
    extends _$ProjectTimerShellPageController {
  /// Needed to check if mounted.
  final initial = Object();

  /// Needed to check if mounted.
  late Object current = initial;

  /// Returns true if the screen is mounted.
  bool get mounted => current == initial;
  late final TimerService _timerService;
  @override
  FutureOr<ProjectTimerPageState> build(
    String projectId,
  ) async {
    ref.onDispose(() {
      current = Object();
    });
    TimerServiceData timerData;

    final timerModel = await ref.read(timerDataProvider(projectId).future);
    _timerService = ref.watch(timerServiceProvider);

    _timerService.init(
      interval: const Duration(seconds: 1),
      tickEvent: _timerCallBack,
      timerData: timerModel != null
          ? TimerServiceData(
              start: timerModel.startTime,
              breakStarts: timerModel.breakStartTimes,
              breakEnds: timerModel.breakEndTimes,
              state: timerModel.state,
            )
          : null,
    );
    // there is no timer
    if (timerModel == null) {
      return ProjectTimerPageState(
        timerData: null,
        duration: Duration.zero,
      );
    }
    // there is a timer running
    else if (timerModel.state == TimerState.running) {
      timerData = _timerService.startTimer();
    }
    // there is a timer which is paused
    else {
      timerData = _timerService.timerServiceData!;
    }

    return ProjectTimerPageState(
      timerData: timerModel.copyWith(
        startTime: timerData.start,
        breakStartTimes: timerData.breakStarts,
        breakEndTimes: timerData.breakEnds,
        state: timerData.state,
      ),
      duration: _timerService.timerServiceData!.totalRun,
    );
  }

  void _timerCallBack(Duration elapsed) {
    state = AsyncData(state.value!.copyWith(duration: elapsed));
  }

  /// Handles the tap on the start button.
  Future<bool> startTimer(String projectId) async {
    return _startTimerWithRollback(projectId, (timerData) async {
      final model = ProjectTimerModel(
        projectId: projectId,
        startTime: timerData.start,
        breakStartTimes: timerData.breakStarts,
        breakEndTimes: timerData.breakEnds,
        state: timerData.state,
      );
      state = await AsyncValue.guard<ProjectTimerPageState>(() async {
        await ref.read(timerDataRepositoryProvider).saveTimerData(model);
        return state.value!.copyWith(timerData: model, duration: Duration.zero);
      });
      return !state.hasError;
    });
  }

  Future<bool> _startTimerWithRollback(
    String projectId,
    Future<bool> Function(TimerServiceData data) callback,
  ) async {
    final timerData = _timerService.startTimer();
    final succes = await callback(timerData);

    if (!succes) {
      _timerService.cancelTimer();
    }

    return succes;
  }

  /// Handles the tap on the stop button.
  Future<void> stopTimer(
    BuildContext context,
    ProjectModel project,
  ) async {
    final timerData = _timerService.cancelTimer();
    await ref.read(timerDataRepositoryProvider).deleteTimerData();

    final entry = TimeEntryModel(
      projectId: projectId,
      startTime: timerData.start,
      endTime: timerData.end!,
      totalTime: timerData.totalRun,
      breakTime: timerData.totalBreak,
      description: '',
    );
    state = await AsyncValue.guard(() async {
      await ref.read(timeEntriesRepositoryProvider).saveTimeEntry(entry);
      return state.value!.copyWith(
        timerData: ProjectTimerModel(
          projectId: projectId,
          startTime: timerData.start,
          breakStartTimes: timerData.breakStarts,
          breakEndTimes: timerData.breakEnds,
          state: timerData.state,
        ),
      );
    });

    if (!state.hasError) {
      if (mounted) {
        pushNamedTimeEntryForm(
          context: context,
          project: project,
          isEdit: true,
          entry: entry,
        );
        state = AsyncValue.data(state.value!.copyWith(duration: Duration.zero));
      }
    }
  }

  /// Handles the tap on the pause/resume button.
  Future<void> pauseResumeTimer() async {
    _timerService.pauseResumeTimer();
    final currentTimerData = state.value!.timerData!;

    final newTimerData =
        await ref.read(timerDataRepositoryProvider).updateTimerDataState(
              currentTimerData.copyWith(
                state: currentTimerData.state == TimerState.running
                    ? TimerState.paused
                    : TimerState.running,
              ),
              DateTime.now().toUtc(),
            );
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));
  }

  /// Handles the tap on the add break button.
  void pushNamedTimeEntryForm({
    required BuildContext context,
    required ProjectModel project,
    required bool isEdit,
    TimeEntryModel? entry,
  }) {
    final tid = entry?.id ?? '';
    context.pushNamed(
      AppRoute.timeEntryForm,
      pathParameters: {
        'pid': project.id,
      },
      queryParameters: {
        'tid': tid,
        'pname': project.name,
        'isEdit': isEdit.toString(),
      },
    );
  }
}

/// Provides TimerData from the Repository.
final timerDataProvider = FutureProvider.autoDispose
    .family<ProjectTimerModel?, String>((ref, projectId) {
  final timerDataRepo = ref.read(timerDataRepositoryProvider);
  return timerDataRepo.fetchTimerData(projectId);
});

/// Provides the Project.
final projectFutureProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectsRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});
