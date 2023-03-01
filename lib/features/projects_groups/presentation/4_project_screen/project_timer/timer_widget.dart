import 'package:flutter/material.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/features/projects_groups/domain/custom_timer.dart';
import 'package:my_time/features/projects_groups/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/features/projects_groups/presentation/4_project_screen/staggered_buttons.dart';

class TimerWidget extends StatefulWidget {
  late CustomTimer timer;
  final AnimationController controller;
  late EdgeInsets padding;
  TimerWidget(
      {super.key,
      required this.timer,
      required this.controller,
      this.padding = const EdgeInsets.only(left: 15, right: 15)});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeDisplay(duration: widget.timer.duration),
        SizedBox(
          height: gapH52.height!,
          child: StaggeredButtons(
            controller: widget.controller,
            timerIsActive: widget.timer.isActive(),
            onStart: () {
              widget.timer.startTimer();
            },
            onFinish: () {
              widget.timer.stopTimer();
            },
            onPause: () {
              setState(() {
                widget.timer.pauseResumeTimer();
              });
            },
          ),
        ),
      ],
    );
  }
}
