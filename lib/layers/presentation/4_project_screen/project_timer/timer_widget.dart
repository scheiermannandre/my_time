import 'package:flutter/material.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/time_display.dart';
import 'package:my_time/layers/presentation/4_project_screen/staggered_buttons.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';

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
