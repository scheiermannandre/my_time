import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_loading_state.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/layers/presentation/4_project_screen/staggered_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ref.watch(projectScreenControllerProvider.notifier);
    final projectScreenState = ref.watch(projectScreenControllerProvider);
    final timerData = ref.watch(timerDataProvider(project.id));
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
              btnStartLabel: AppLocalizations.of(context)!.btnStartLabel,
              btnFinishLabel: AppLocalizations.of(context)!.btnFinishLabel,
              btnPauseLabel: AppLocalizations.of(context)!.btnPauseLabel,
              btnResumeLabel: AppLocalizations.of(context)!.btnResumeLabel,
              controller: animationController,
              timerState: timerData.value!.state,
              onStart: () => projectScreenController.startTimer(project),
              onFinish: () =>
                  projectScreenController.stopTimer(context, project),
              onPause: () => projectScreenController.pauseResumeTimer(project),
            ),
          ),
        ],
      ),
      error: (error, stackTrace) => LoadingErrorWidget(
        onRefresh: () =>
            projectScreenState.value!.refreshIndicatorKey.currentState!.show(),
      ),
      loading: () => const ProjectScreenLoadingState(),
    );
  }
}
