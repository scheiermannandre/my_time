import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/router/app_route.dart';

import 'dart:async' as async;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_timer_shell_page_controller.g.dart';

class ProjectTimerPageState {
  ProjectTimerPageState({required this.timerData, required this.duration})
      : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  ProjectTimerPageState._private(
      {required this.timerData,
      required this.duration,
      required this.refreshIndicatorKey});

  final ProjectTimerModel? timerData;
  final Duration duration;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

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

@riverpod
class ProjectTimerShellPageController
    extends _$ProjectTimerShellPageController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  async.Timer? timer;

  @override
  FutureOr<ProjectTimerPageState> build(String projectId) async {
    ref.onDispose(() {
      current = Object();
      timer?.cancel();
    });
    final timerData = await ref.read(timerDataProvider(projectId).future);
    Duration duration = Duration.zero;
    if (timerData != null && timerData.state == TimerState.running) {
      _startTimer();
      duration = _getTimerDuration(timerData);
    }
    return ProjectTimerPageState(timerData: timerData, duration: duration);
  }

  Duration _getTimerDuration(ProjectTimerModel timerData) {
    // count all breakTimes
    Duration breakTime = _calculateBreakTimer(timerData);
    return DateTime.now().toUtc().difference(timerData.startTime) - breakTime;
  }

  Duration _calculateBreakTimer(ProjectTimerModel timerData) {
    Duration breakTime = Duration.zero;
    for (int i = 0; i < timerData.breakStartTimes.length; i++) {
      DateTime breakStart = timerData.breakStartTimes[i];
      DateTime breakEnd = timerData.breakEndTimes[i];
      breakTime += breakEnd.difference(breakStart);
    }
    return breakTime;
  }

  void timerCallBack() {
    Duration duration = _getTimerDuration(state.value!.timerData!);
    state = AsyncData(state.value!.copyWith(duration: duration));
  }

  void _startTimer() {
    timer = ref.read(timerServiceProvider).startTimer(timerCallBack);
  }

  Future<bool> startTimer(String projectId) async {
    ProjectTimerModel timerData = ProjectTimerModel(
        projectId: projectId,
        startTime: DateTime.now().toUtc(),
        endTime: DateTime(9999),
        breakStartTimes: [],
        breakEndTimes: [],
        state: TimerState.running);
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

  void stopTimer(BuildContext context, ProjectModel project) async {
    ref.read(timerServiceProvider).stopTimer();
    ProjectTimerModel newTimerData = await ref
        .read(timerDataRepositoryProvider)
        .deleteTimerData(state.value!.timerData!, DateTime.now().toUtc());
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));

    TimeEntryModel entry = TimeEntryModel(
      projectId: projectId,
      startTime: newTimerData.startTime,
      endTime: newTimerData.endTime,
      totalTime: state.value!.duration,
      breakTime: _calculateBreakTimer(newTimerData),
      description: "",
    );
    state = await AsyncValue.guard(() async {
      await ref.read(timeEntriesRepositoryProvider).saveTimeEntry(entry);
      return state.value!.copyWith();
    });

    //ref.invalidate(projectHistoryProvider(project.id));

    if (!state.hasError) {
      if (mounted) {
        pushNamedTimeEntryForm(context, project, true, entry);
        state = AsyncValue.data(state.value!.copyWith(duration: Duration.zero));
      }
    }
  }

  void pauseResumeTimer() async {
    ref.read(timerServiceProvider).pauseResumeTimer();
    ProjectTimerModel currentTimerData = state.value!.timerData!;

    ProjectTimerModel newTimerData = await ref
        .read(timerDataRepositoryProvider)
        .updateTimerDataState(
            currentTimerData.copyWith(
                state: currentTimerData.state == TimerState.running
                    ? TimerState.paused
                    : TimerState.running),
            DateTime.now().toUtc());
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));
  }

  void pushNamedTimeEntryForm(
      BuildContext context, ProjectModel project, bool isEdit,
      [TimeEntryModel? entry]) {
    String tid = entry?.id ?? "";
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

final timerDataProvider = FutureProvider.autoDispose
    .family<ProjectTimerModel?, String>((ref, projectId) {
  final timerDataRepo = ref.read(timerDataRepositoryProvider);
  return timerDataRepo.fetchTimerData(projectId);
});
