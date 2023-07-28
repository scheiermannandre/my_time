import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/router/app_route.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_shell_screen_controller.g.dart';

@riverpod
class ProjectShellScreenController extends _$ProjectShellScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  void build(String projectId) async {
    ref.onDispose(() {
      current = Object();
    });
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
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

  Future<void> showDeleteBottomSheet(BuildContext context, ProjectModel project,
      AnimationController controller) async {
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
              .deleteProject(project.id);

          return result;
        },
        whenCompleted: (result, mounted) async {
          if (result) {
            //ref.invalidate(groupsDataProvider);
            //ref.invalidate(groupWithProjectsDTOProvider(project.groupId));
          }
          if (result && !mounted) {
            ref.invalidate(projectProvider(project.id));
          }
        },
      );
    }
  }

  Future<void> changeIsFavouriteState(ProjectModel project) async {
    project = project.copyWith(
      isMarkedAsFavourite: !project.isMarkedAsFavourite,
    );
    await ref
        .read(projectsRepositoryProvider)
        .updateIsFavouriteState(project.id, project.isMarkedAsFavourite);
    ref.invalidate(projectProvider(project.id));
    //ref.invalidate(groupsDataProvider);
  }

  Future<void> _delete(BuildContext context, bool? deletePressed) async {
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

final projectProvider =
    FutureProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectsRepositoryProvider);
  return projectRepo.fetchProject(projectId);
});
