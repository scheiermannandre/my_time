import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_shell_screen_controller.g.dart';

/// State of the ProjectShellScreen.
@riverpod
class ProjectShellScreenController extends _$ProjectShellScreenController {
  /// Needed to check if mounted.
  final initial = Object();

  /// Needed to check if mounted.
  late Object current = initial;

  /// Returns true if the screen is mounted.
  bool get mounted => current == initial;
  @override
  Future<void> build(String projectId) async {
    ref.onDispose(() {
      current = Object();
    });
  }

  /// Handles the swtich between the pages.
  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  /// Handles the tap on the add time entry button.
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

  /// Handles the tap on the delete project button.
  Future<void> showDeleteBottomSheet(
    BuildContext context,
    ProjectModel project,
    AnimationController controller,
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
      );
    }
  }

  /// Handles the tap on the start button.
  Future<void> changeIsFavouriteState(ProjectModel project) async {
    final newProjectState = project.copyWith(
      isMarkedAsFavourite: !project.isMarkedAsFavourite,
    );
    await ref.read(projectsRepositoryProvider).updateIsFavouriteState(
          newProjectState.id,
          isFavourite: newProjectState.isMarkedAsFavourite,
        );
  }

  Future<void> _delete(BuildContext context, bool? deletePressed) async {
    if (deletePressed ?? false) {
      if (mounted) {
        pop(context);
      }
    }
  }

  /// Handles the tap on the back button.
  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }
}

/// Streams the project from the database.
final projectProvider =
    StreamProvider.autoDispose.family<ProjectModel?, String>((ref, projectId) {
  final projectRepo = ref.read(projectsRepositoryProvider);
  return projectRepo.streamProject(projectId);
});
