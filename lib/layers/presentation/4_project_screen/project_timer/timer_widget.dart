import 'package:flutter/material.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/layers/presentation/4_project_screen/staggered_buttons.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';

class TimerWidget extends StatefulWidget {
  // late CustomTimer timer;
  final Duration duration;
  final AnimationController controller;
  late EdgeInsets padding;
  final VoidCallback onStartTimer;
  final VoidCallback onStopTimer;
  final VoidCallback onPauseResumeTimer;
  final TimerState timerState;

  TimerWidget({
    super.key,
    //required this.timer,
    required this.controller,
    this.padding = const EdgeInsets.only(left: 15, right: 15),
    required this.duration,
    required this.onStartTimer,
    required this.onStopTimer,
    required this.onPauseResumeTimer,
    required this.timerState,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeDisplay(duration: widget.duration),
        SizedBox(
          height: gapH52.height!,
          child: StaggeredButtons(
            controller: widget.controller,
            timerState: widget.timerState,
            onStart: widget.onStartTimer,
            onFinish: widget.onStopTimer,
            onPause: widget.onPauseResumeTimer,
          ),
        ),
      ],
    );
  }
}
