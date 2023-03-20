import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/layers/application/projects_screen_service.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/timer_data.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'project_screen_controller.g.dart';

@riverpod
class ProjectScreenController extends _$ProjectScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
  }

  void startTimer(String projectId) {
    ref.read(projectsScreenServiceProvider).startTimer(projectId);
  }

  void stopTimer(String projectId) {
    ref.read(projectsScreenServiceProvider).stopTimer(projectId);
  }

  void pauseResumeTimer(String projectId) {
    ref.read(projectsScreenServiceProvider).pauseResumeTimer(projectId);
  }

  void onItemTapped(PageController controller, int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void pushNamedTimeEntryForm(BuildContext context, String projectId,
      [TimeEntry? entry]) {
    String tid = entry?.id ?? "";
    return context.pushNamed(
      AppRoute.timeEntryForm,
      params: {
        'pid': projectId,
      },
      queryParams: {'tid': tid, 'pname': projectId},
    );
  }

  Future<void> showDeleteBottomSheet(BuildContext context, String projectId,
      AnimationController controller) async {
    {
      bool? deletePressed = await openBottomSheet(
          context: context,
          bottomSheetController: controller,
          title: "Delete Project $projectId?",
          message: "All Entries for the Project will be lost!",
          confirmBtnText: "Confirm",
          onCanceled: () {
            Navigator.of(context).pop(false);
          },
          onConfirmed: () {
            Navigator.of(context).pop(true);
          });

      if (deletePressed ?? false) {
        //ToDo
        //Delete Project
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
  final service = ref.read(projectsScreenServiceProvider);
  return service.watchTimerData(projectId);
});
