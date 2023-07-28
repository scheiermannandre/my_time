import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/router/app_route.dart';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_history_shell_page_controller.g.dart';

class ProjectHistoryShellPageState {
  ProjectHistoryShellPageState()
      : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
}

@riverpod
class ProjectHistoryShellPageController
    extends _$ProjectHistoryShellPageController {
  @override
  FutureOr<ProjectHistoryShellPageState> build(String projectId) {
    return ProjectHistoryShellPageState();
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

  Stream<List<List<TimeEntryModel>>?> watchAllEntriesGroupedByMonth(
      String projectId) async* {
    final timeEntriesRepository = ref.read(projectHistoryRepositoryProvider);
    yield* Stream.fromFuture(
        timeEntriesRepository.getAllProjectEntriesGroupedByMonth(projectId));
  }
}

// Use .family when you need to pass an argument
final projectHistoryProvider = StreamProvider.autoDispose
    .family<List<List<TimeEntryModel>>?, String>((ref, projectId) {
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
  final service =
      ref.read(projectHistoryShellPageControllerProvider(projectId).notifier);
  return service.watchAllEntriesGroupedByMonth(projectId);
});

final projectProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectHistoryRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});
