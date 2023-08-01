import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_projects_shell_page_controller.g.dart';

/// State of the GroupProjectsShellPage.
class GroupProjectsShellPageState {
  /// Creates a [GroupProjectsShellPageState].
  GroupProjectsShellPageState();

  /// The key of the [RefreshIndicator].
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
}

/// Controller for the GroupProjectsShellPage.
@riverpod
class GroupProjectsShellPageController
    extends _$GroupProjectsShellPageController {
  /// Needed to check if mounted.
  final initial = Object();

  /// Needed to check if mounted.
  late Object current = initial;

  /// Returns true if the screen is mounted.
  bool get mounted => current == initial;
  @override
  FutureOr<GroupProjectsShellPageState> build() {
    ref.onDispose(() => current = Object());
    // nothing to do
    return GroupProjectsShellPageState();
  }

  /// Handles the tap on the add project button.
  void pushNamedAddProject(BuildContext context, GroupProjectsPageModel dto) {
    context
        .pushNamed(AppRoute.addProject, queryParameters: {'gid': dto.group.id});
  }

  /// Handles the tap on the project list tile.
  void pushNamedProject(
    BuildContext context,
    List<ProjectModel> projects,
    int index,
  ) {
    context.pushNamed(
      AppRoute.project,
      pathParameters: {'pid': projects[index].id},
    );
  }

  void _pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  /// Handles the tap on the delete group button.
  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    GroupProjectsPageModel model,
  ) async {
    {
      bool? deletePressed = false;
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _delete(context, deletePressed);
        }
      }

      controller
        ..removeStatusListener(listener)
        ..addStatusListener(listener);
      deletePressed = await openBottomSheet(
        context: context,
        bottomSheetController: controller,
        title: context.loc.deleteGroupTitle(model.group.name),
        message: context.loc.deleteGroupMessage,
        confirmBtnText: context.loc.deleteGroupConfirmBtnLabel,
        cancelBtnText: context.loc.deleteGroupCancelBtnLabel,
        onCanceled: () {
          Navigator.of(context).pop(false);
        },
        onConfirmed: () async {
          final result = await ref
              .read(groupProjectsScreenServiceProvider)
              .deleteGroup(model.group.id);
          return result;
        },
      );
    }
  }

  Future<void> _delete(BuildContext context, bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        _pop(context);
      }
    }
  }
}

/// Streams the [GroupProjectsPageModel] from the GroupProjectsScreenService.
final groupProjectsProvider = StreamProvider.autoDispose
    .family<GroupProjectsPageModel, String>((ref, groupId) {
  final service = ref.watch(groupProjectsScreenServiceProvider);
  return service.streamGroupProjectsPageModel(groupId);
});
