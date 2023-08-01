import 'dart:async' as async;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_timer_shell_page_controller.g.dart';

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

  /// The Timer that is used to update the timer duration.
  async.Timer? timer;

  @override
  FutureOr<ProjectTimerPageState> build(String projectId) async {
    ref.onDispose(() {
      current = Object();
      timer?.cancel();
    });
    final timerData = await ref.read(timerDataProvider(projectId).future);
    var duration = Duration.zero;
    if (timerData != null && timerData.state == TimerState.running) {
      _startTimer();
      duration = _getTimerDuration(timerData);
    }
    return ProjectTimerPageState(timerData: timerData, duration: duration);
  }

  Duration _getTimerDuration(ProjectTimerModel timerData) {
    // count all breakTimes
    final breakTime = _calculateBreakTimer(timerData);
    return DateTime.now().toUtc().difference(timerData.startTime) - breakTime;
  }

  Duration _calculateBreakTimer(ProjectTimerModel timerData) {
    var breakTime = Duration.zero;
    for (var i = 0; i < timerData.breakStartTimes.length; i++) {
      final breakStart = timerData.breakStartTimes[i];
      final breakEnd = timerData.breakEndTimes[i];
      breakTime += breakEnd.difference(breakStart);
    }
    return breakTime;
  }

  void _timerCallBack() {
    final duration = _getTimerDuration(state.value!.timerData!);
    state = AsyncData(state.value!.copyWith(duration: duration));
  }

  void _startTimer() {
    timer = ref.read(timerServiceProvider).startTimer(_timerCallBack);
  }

  /// Handles the tap on the start button.
  Future<bool> startTimer(String projectId) async {
    final timerData = ProjectTimerModel(
      projectId: projectId,
      startTime: DateTime.now().toUtc(),
      endTime: DateTime(9999),
      breakStartTimes: [],
      breakEndTimes: [],
      state: TimerState.running,
    );
    state = await AsyncValue.guard<ProjectTimerPageState>(() async {
      final data =
          await ref.read(timerDataRepositoryProvider).saveTimerData(timerData);
      return state.value!.copyWith(timerData: data, duration: Duration.zero);
    });

    if (state.hasError) {
      return false;
    }
    _startTimer();
    return true;
  }

  /// Handles the tap on the stop button.
  async.Future<void> stopTimer(
    BuildContext context,
    ProjectModel project,
  ) async {
    ref.read(timerServiceProvider).stopTimer();
    final newTimerData = await ref
        .read(timerDataRepositoryProvider)
        .deleteTimerData(state.value!.timerData!, DateTime.now().toUtc());
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));

    final entry = TimeEntryModel(
      projectId: projectId,
      startTime: newTimerData.startTime,
      endTime: newTimerData.endTime,
      totalTime: state.value!.duration,
      breakTime: _calculateBreakTimer(newTimerData),
      description: '',
    );
    state = await AsyncValue.guard(() async {
      await ref.read(timeEntriesRepositoryProvider).saveTimeEntry(entry);
      return state.value!.copyWith();
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
  async.Future<void> pauseResumeTimer() async {
    ref.read(timerServiceProvider).pauseResumeTimer();
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
