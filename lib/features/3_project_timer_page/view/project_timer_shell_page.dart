import 'package:my_time/common/common.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectTimerShellPage extends ProjectShellPage {
  final String projectId;
  ProjectTimerShellPage({
    super.key,
    required this.projectId,
    required BuildContext context,
  }) : super(
          iconData: Icons.timer_sharp,
          label: context.loc.timerTabLabel,
        );

  const ProjectTimerShellPage.factory({
    super.key,
    required this.projectId,
    required String label,
    required IconData iconData,
    required ScrollController controller,
  }) : super(
          iconData: iconData,
          label: label,
          scrollController: controller,
        );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider(projectId));
    final state = ref.watch(projectTimerShellPageControllerProvider(projectId));

    final projectScreenController =
        ref.watch(projectTimerShellPageControllerProvider(projectId).notifier);
    final projectScreenState =
        ref.watch(projectTimerShellPageControllerProvider(projectId));

    ref.listen<AsyncValue>(
      projectTimerShellPageControllerProvider(projectId),
      (_, state) => state.showAlertDialogOnError(context),
      onError: (error, stackTrace) {},
    );
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 2000),
    );

    return Scaffold(
      body: project.when(
        data: (data) => ResponsiveAlign(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimeDisplay(
                  duration: projectScreenState.value != null
                      ? projectScreenState.value!.duration
                      : Duration.zero),
              SizedBox(
                height: gapH52.height!,
                child: StaggeredButtons(
                  btnStartLabel: context.loc.btnStartLabel,
                  btnFinishLabel: context.loc.btnFinishLabel,
                  btnPauseLabel: context.loc.btnPauseLabel,
                  btnResumeLabel: context.loc.btnResumeLabel,
                  controller: animationController,
                  timerState: projectScreenState.value != null
                      ? projectScreenState.value!.timerData?.state ??
                          TimerState.off
                      : TimerState.off,
                  onStart: () async {
                    return await projectScreenController.startTimer(data!.id);
                  },
                  onFinish: () =>
                      projectScreenController.stopTimer(context, data!),
                  onPause: () => projectScreenController.pauseResumeTimer(),
                ),
              ),
            ],
          ),
        ),
        error: (ex, st) => LoadingErrorWidget(
          onRefresh: () =>
              state.value!.refreshIndicatorKey.currentState?.show(),
        ),
        loading: () => const ProjectTimerShellPageLoadingState(),
      ),
    );
  }

  @override
  ProjectShellPage copyWith({
    required ScrollController controller,
  }) {
    return ProjectTimerShellPage.factory(
      projectId: projectId,
      label: label,
      iconData: iconData,
      controller: controller,
    );
  }
}
