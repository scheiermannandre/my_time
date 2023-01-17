import 'package:flutter/material.dart';
import 'package:my_time/logic/custom_timer.dart';
import 'package:my_time/widgets/staggered_buttons.dart';
import 'package:my_time/widgets/time_display.dart';

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
    return Padding(
      padding: widget.padding,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimeDisplay(duration: widget.timer.duration),
            StaggeredButtons(
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
          ],
        ),
      ),
    );
  }
}
