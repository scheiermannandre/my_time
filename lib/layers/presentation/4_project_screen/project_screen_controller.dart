// ignore_for_file: unused_result

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/layers/application/projects_screen_service.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/timer_data.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'project_screen_controller.g.dart';

class ProjectScreenState {
  ProjectScreenState();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
}

@riverpod
class ProjectScreenController extends _$ProjectScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<ProjectScreenState> build() {
    ref.onDispose(() => current = Object());
    return ProjectScreenState();
  }

  void startTimer(ProjectDTO project) {
    ref.read(projectsScreenServiceProvider).startTimer(project.id);
  }

  void stopTimer(BuildContext context, ProjectDTO project) async {
    final entry =
        await ref.read(projectsScreenServiceProvider).stopTimer(project.id);
    if (entry != null) {
      await ref.refresh(projectTimeEntriesProvider(project.id).future);
      if (mounted) {
        pushNamedTimeEntryForm(context, project, entry);
      }
    }
  }

  void pauseResumeTimer(ProjectDTO project) {
    ref.read(projectsScreenServiceProvider).pauseResumeTimer(project.id);
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void pushNamedTimeEntryForm(BuildContext context, ProjectDTO project,
      [TimeEntryDTO? entry]) {
    String tid = entry?.id ?? "";
    return context.pushNamed(
      AppRoute.timeEntryForm,
      params: {
        'pid': project.id,
      },
      queryParams: {'tid': tid, 'pname': project.name},
    );
  }

  Future<void> showDeleteBottomSheet(BuildContext context, ProjectDTO project,
      AnimationController controller) async {
    {
      bool? deletePressed = await openBottomSheet(
          context: context,
          bottomSheetController: controller,
          title: "Delete Project ${project.name}?",
          message: "All Entries for the Project will be lost!",
          confirmBtnText: "Confirm",
          onCanceled: () {
            Navigator.of(context).pop(false);
          },
          onConfirmed: () {
            Navigator.of(context).pop(true);
          });

      if (deletePressed ?? false) {
        if (mounted) {
          _delete(context, project);
        }
      }
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

  Future<void> _delete(BuildContext context, ProjectDTO project) async {
    final result =
        await ref.read(projectsScreenServiceProvider).deleteProject(project);
    if (result) {
      await ref.refresh(groupWithProjectsDTOProvider(project.groupId).future);
      await ref.refresh(homePageDataProvider.future);
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

final timerDataProvider =
    StreamProvider.autoDispose.family<TimerData, String>((ref, projectId) {
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
  return service.watchTimerData(projectId);
});

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
