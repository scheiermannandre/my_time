import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// The ProjectTimerPage that displays the timer.
class ProjectTimerShellPage extends ProjectShellPage {
  /// Creates a [ProjectTimerShellPage].
  const ProjectTimerShellPage({
    required this.projectId,
    super.key,
  }) : super();

  /// Creates a [ProjectTimerShellPage] with a factory constructor.
  const ProjectTimerShellPage.factory({
    required this.projectId,
    required ScrollController controller,
    super.key,
  }) : super(
          scrollController: controller,
        );

  /// The id of the project.
  final String projectId;

  @override
  String getLabel(BuildContext context) => context.loc.timerTabLabel;

  @override
  IconData getIconData() => Icons.timer_sharp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectFutureProvider(projectId));
    final state = ref.watch(projectTimerShellPageControllerProvider(projectId));

    final projectScreenController =
        ref.watch(projectTimerShellPageControllerProvider(projectId).notifier);
    final projectScreenState =
        ref.watch(projectTimerShellPageControllerProvider(projectId));

    ref.listen<AsyncValue<void>>(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TimeDisplay(
                duration: projectScreenState.value != null
                    ? projectScreenState.value!.duration
                    : Duration.zero,
              ),
              SizedBox(
                height: gapH52.height,
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
                  onStart: () => projectScreenController.startTimer(data!.id),
                  onFinish: () =>
                      projectScreenController.stopTimer(context, data!),
                  onPause: projectScreenController.pauseResumeTimer,
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
      controller: controller,
    );
  }
}
