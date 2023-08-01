import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_history_shell_page_controller.g.dart';

/// State of the ProjectHistoryShellPage.
class ProjectHistoryShellPageState {
  /// Creates a [ProjectHistoryShellPageState].
  ProjectHistoryShellPageState()
      : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  /// The key of the [RefreshIndicator].
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
}

/// Controller for the ProjectHistoryShellPage.
@riverpod
class ProjectHistoryShellPageController
    extends _$ProjectHistoryShellPageController {
  @override
  FutureOr<ProjectHistoryShellPageState> build(String projectId) {
    return ProjectHistoryShellPageState();
  }

  /// Handles the tap on a TimeEntryTile
  void pushNamedTimeEntryForm(
    BuildContext context,
    ProjectModel project, {
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

/// Provides the Project.
final projectProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectHistoryRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});
