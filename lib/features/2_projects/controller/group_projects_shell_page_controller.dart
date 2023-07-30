import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:my_time/router/app_route.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_projects_shell_page_controller.g.dart';

class GroupProjectsShellPageState {
  GroupProjectsShellPageState();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
}

@riverpod
class GroupProjectsShellPageController
    extends _$GroupProjectsShellPageController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<GroupProjectsShellPageState> build() {
    ref.onDispose(() => current = Object());
    // nothing to do
    return GroupProjectsShellPageState();
  }

  void pushNamedAddProject(BuildContext context, GroupProjectsPageModel dto) {
    context
        .pushNamed(AppRoute.addProject, queryParameters: {'gid': dto.group.id});
  }

  void pushNamedProject(
      BuildContext context, List<ProjectModel> projects, int index) {
    context.pushNamed(AppRoute.project,
        pathParameters: {'pid': projects[index].id});
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<void> showDeleteBottomSheet(
    BuildContext context,
    AnimationController controller,
    GroupProjectsPageModel model,
  ) async {
    {
      bool? deletePressed = false;
      listener(status) {
        if (status == AnimationStatus.dismissed) {
          _delete(context, deletePressed);
        }
      }

      controller.removeStatusListener(listener);
      controller.addStatusListener(listener);
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
        pop(context);
      }
    }
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}

final groupProjectsProvider = StreamProvider.autoDispose
    .family<GroupProjectsPageModel, String>((ref, groupId) {
  final service = ref.watch(groupProjectsScreenServiceProvider);
  return service.streamGroupProjectsPageModel(groupId);
});
