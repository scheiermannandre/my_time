import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/layers/presentation/4_project_screen/staggered_buttons.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';

class TimerWidget extends HookConsumerWidget {
  final EdgeInsets padding;
  final ProjectDTO project;
  const TimerWidget({
    super.key,
    this.padding = const EdgeInsets.only(left: 15, right: 15),
    required this.project,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectScreenController =
        ref.watch(projectScreenControllerProvider(project.id).notifier);
    final projectScreenState =
        ref.watch(projectScreenControllerProvider(project.id));

    ref.listen<AsyncValue>(
      projectScreenControllerProvider(project.id),
      (_, state) => state.showAlertDialogOnError(context),
      onError: (error, stackTrace) {},
    );
    //final timerData = ref.watch(timerDataProvider(project.id));
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 2000),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeDisplay(duration: projectScreenState.value!.duration),
        SizedBox(
          height: gapH52.height!,
          child: StaggeredButtons(
            btnStartLabel: context.loc.btnStartLabel,
            btnFinishLabel: context.loc.btnFinishLabel,
            btnPauseLabel: context.loc.btnPauseLabel,
            btnResumeLabel: context.loc.btnResumeLabel,
            controller: animationController,
            timerState:
                projectScreenState.value!.timerData?.state ?? TimerState.off,
            onStart: () async {
              return await projectScreenController.startTimer(project);
            },
            onFinish: () => projectScreenController.stopTimer(context, project),
            onPause: () => projectScreenController.pauseResumeTimer(project),
          ),
        ),
      ],
    );
  }
}
