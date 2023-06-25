// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_result

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/layers/application/timer_service.dart';
import 'package:my_time/layers/data/time_entries_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/layers/application/projects_screen_service.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/data/timer_repository.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/interface/dto/timer_data_dto.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';
import 'package:my_time/router/app_route.dart';

part 'project_screen_controller.g.dart';

class ProjectScreenState {
  ProjectScreenState({required this.timerData, required this.duration})
      : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  ProjectScreenState._private(
      {required this.timerData,
      required this.duration,
      required this.refreshIndicatorKey});

  final TimerDataDto? timerData;
  final Duration duration;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  ProjectScreenState copyWith({
    TimerDataDto? timerData,
    Duration? duration,
  }) {
    return ProjectScreenState._private(
      timerData: timerData ?? this.timerData,
      duration: duration ?? this.duration,
      refreshIndicatorKey: refreshIndicatorKey,
    );
  }
}

@riverpod
class ProjectScreenController extends _$ProjectScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  Timer? timer;
  @override
  FutureOr<ProjectScreenState> build(String projectId) async {
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
    return ProjectScreenState(timerData: timerData, duration: duration);
  }

  Future<bool> startTimer(ProjectDTO project) async {
    TimerDataDto timerData = TimerDataDto(
        projectId: project.id,
        startTime: DateTime.now().toUtc(),
        endTime: DateTime(9999),
        breakStartTimes: [],
        breakEndTimes: [],
        state: TimerState.running);
    state = await AsyncValue.guard<ProjectScreenState>(() async {
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

  void _startTimer() {
    timer = ref.read(timerServiceProvider).startTimer(timerCallBack);
  }

  void timerCallBack() {
    Duration duration = _getTimerDuration(state.value!.timerData!);
    state = AsyncData(state.value!.copyWith(duration: duration));
  }

  Duration _getTimerDuration(TimerDataDto timerData) {
    // count all breakTimes
    Duration breakTime = _calculateBreakTimer(timerData);
    return DateTime.now().toUtc().difference(timerData.startTime) - breakTime;
  }

  Duration _calculateBreakTimer(TimerDataDto timerData) {
    Duration breakTime = Duration.zero;
    for (int i = 0; i < timerData.breakStartTimes.length; i++) {
      DateTime breakStart = timerData.breakStartTimes[i];
      DateTime breakEnd = timerData.breakEndTimes[i];
      breakTime += breakEnd.difference(breakStart);
    }
    return breakTime;
  }

  void stopTimer(BuildContext context, ProjectDTO project) async {
    ref.read(timerServiceProvider).stopTimer();
    TimerDataDto newTimerData = await ref
        .read(timerDataRepositoryProvider)
        .deleteTimerData(state.value!.timerData!, DateTime.now().toUtc());
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));

    TimeEntryDTO entry = TimeEntryDTO(
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
    await ref.refresh(projectTimeEntriesProvider(project.id).future);

    if (!state.hasError) {
      if (mounted) {
        pushNamedTimeEntryForm(context, project, true, entry);
        state = AsyncValue.data(state.value!.copyWith(duration: Duration.zero));
      }
    }
  }

  void pauseResumeTimer(ProjectDTO project) async {
    ref.read(timerServiceProvider).pauseResumeTimer();
    TimerDataDto currentTimerData = state.value!.timerData!;

    TimerDataDto newTimerData = await ref
        .read(timerDataRepositoryProvider)
        .updateTimerDataState(
            currentTimerData.copyWith(
                state: currentTimerData.state == TimerState.running
                    ? TimerState.paused
                    : TimerState.running),
            DateTime.now().toUtc());
    state = AsyncValue.data(state.value!.copyWith(timerData: newTimerData));
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void pushNamedTimeEntryForm(
      BuildContext context, ProjectDTO project, bool isEdit,
      [TimeEntryDTO? entry]) {
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

  Future<void> showDeleteBottomSheet(BuildContext context, ProjectDTO project,
      AnimationController controller) async {
    {
      bool? deletePressed = false;
      listener(status) {
        if (status == AnimationStatus.dismissed) {
          _delete(context, project, deletePressed);
        }
      }

      controller.removeStatusListener(listener);
      controller.addStatusListener(listener);

      deletePressed = await openBottomSheet(
        context: context,
        bottomSheetController: controller,
        title: context.loc.deleteProjectTitle(project.name),
        message: context.loc.deleteProjectMessage,
        confirmBtnText: context.loc.deleteProjectConfirmBtnLabel,
        cancelBtnText: context.loc.deleteProjectCancelBtnLabel,
        onCanceled: () {
          Navigator.of(context).pop(false);
        },
        onConfirmed: () async {
          final result = await ref
              .read(projectsScreenServiceProvider)
              .deleteProject(project);

          return result;
        },
        whenCompleted: (result, mounted) async {
          if (result) {
            ref.invalidate(homePageDataProvider);
            ref.invalidate(groupWithProjectsDTOProvider(project.groupId));
          }
          if (result && !mounted) {
            ref.invalidate(projectProvider(project.id));
          }
        },
      );
    }
  }

  Future<void> markAsFavourite(ProjectDTO project) async {
    project = project.copyWith(
      isMarkedAsFavourite: !project.isMarkedAsFavourite,
    );
    await ref.read(projectsRepositoryProvider).updateIsFavouriteState(project);
    await ref.refresh(projectProvider(project.id).future);
    await ref.refresh(homePageDataProvider.future);
  }

  Future<void> _delete(
      BuildContext context, ProjectDTO project, bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        pop(context);
      }
    }
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }
}

// Use .family when you need to pass an argument
final projectTimeEntriesProvider = StreamProvider.autoDispose
    .family<List<List<TimeEntryDTO>>?, String>((ref, projectId) {
// get the [KeepAliveLink]
  final link = ref.keepAlive();
  // a timer to be used by the callbacks below
  Timer? timer;
  // An object from package:dio that allows cancelling http requests
  final cancelToken = CancelToken();
  // When the provider is destroyed, cancel the http request and the timer
  ref.onDispose(() {
    timer?.cancel();
    cancelToken.cancel();
  });
  // When the last listener is removed, start a timer to dispose the cached data
  ref.onCancel(() {
    // start a 30 second timer
    timer = Timer(const Duration(seconds: 120), () {
      // dispose on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });
  final service = ref.read(projectsScreenServiceProvider);
  return service.watchAllEntriesGroupedByMonth(projectId);
});

final projectProvider =
    FutureProvider.autoDispose.family<ProjectDTO?, String>((ref, projectId) {
  final projectRepo = ref.read(projectsRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});

final timerDataProvider =
    FutureProvider.autoDispose.family<TimerDataDto?, String>((ref, projectId) {
  final timerDataRepo = ref.read(timerDataRepositoryProvider);
  return timerDataRepo.fetchTimerData(projectId);
});
