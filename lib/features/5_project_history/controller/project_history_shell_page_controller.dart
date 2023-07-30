import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/router/app_route.dart';

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

  // Stream<List<List<TimeEntryModel>>?> watchAllEntriesGroupedByMonth(
  //     String projectId) async* {
  //   final timeEntriesRepository = ref.read(projectHistoryRepositoryProvider);
  //   yield* Stream.fromFuture(
  //       timeEntriesRepository.streamProjectEntriesGroupedByMonth(projectId));
  // }
}

final projectProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectHistoryRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});
