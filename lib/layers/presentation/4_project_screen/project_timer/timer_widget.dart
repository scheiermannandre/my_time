import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/layers/presentation/4_project_screen/staggered_buttons.dart';

class TimerWidget extends HookConsumerWidget {
  final EdgeInsets padding;
  final String projectId;

  const TimerWidget({
    super.key,
    this.padding = const EdgeInsets.only(left: 15, right: 15),
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectScreenController =
        ref.watch(projectScreenControllerProvider.notifier);
    final timerData = ref.watch(timerDataProvider(projectId));
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 2000),
    );
    return timerData.when(
      data: (data) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimeDisplay(duration: timerData.value!.duration),
          SizedBox(
            height: gapH52.height!,
            child: StaggeredButtons(
              controller: animationController,
              timerState: timerData.value!.state,
              onStart: () => projectScreenController.startTimer(projectId),
              onFinish: () =>
                  projectScreenController.stopTimer(context, projectId),
              onPause: () =>
                  projectScreenController.pauseResumeTimer(projectId),
            ),
          ),
        ],
      ),
      error: (error, stackTrace) => LoadingErrorWidget(
        onRefresh: () {},
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
