import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// StaggeredButtons that are animated.
class StaggeredButtons extends StatefulWidget {
  /// Creates a [StaggeredButtons].
  const StaggeredButtons({
    required this.onStart,
    required this.onFinish,
    required this.onPause,
    required this.controller,
    required this.timerState,
    required this.btnPauseLabel,
    required this.btnResumeLabel,
    required this.btnStartLabel,
    required this.btnFinishLabel,
    super.key,
  });

  /// Handles the tap on the start button.
  final Future<bool> Function() onStart;

  /// Handles the tap on the finish button.
  final VoidCallback onFinish;

  /// Handles the tap on the pause button.
  final VoidCallback onPause;

  /// The animation controller.
  final AnimationController controller;

  /// The timer state.
  final TimerState timerState;

  /// The label of the pause button.
  final String btnPauseLabel;

  /// The label of the resume button.
  final String btnResumeLabel;

  /// The label of the start button.
  final String btnStartLabel;

  /// The label of the finish button.
  final String btnFinishLabel;

  @override
  State<StaggeredButtons> createState() => _StaggeredButtonsState();
}

class _StaggeredButtonsState extends State<StaggeredButtons>
    with TickerProviderStateMixin {
  late Animation<Size> sizeStartBtn;
  late Animation<double> opacityStartBtn;
  late Animation<Size> sizePauseFinishBtn;
  late Animation<double> opacityPauseFinishBtn;
  late String btnPauseStr;
  late String btnResumeStr;
  late String btnPauseResumeText;
  int Function(int) returnsAFunction() => (int x) => x + 1;

  @override
  void initState() {
    super.initState();
    btnPauseStr = widget.btnPauseLabel;
    btnResumeStr = widget.btnResumeLabel;
    btnPauseResumeText = btnPauseStr;

    // set initial Value of the Animation
    // 0 = start -> timer is not active
    // 1 = end -> timer is running or paused
    if (widget.timerState == TimerState.off) {
      widget.controller.value = 0;
    } else {
      widget.controller.value = 1;
    }

    opacityStartBtn = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller.view,
        curve: const Interval(
          0,
          .25,
          curve: Curves.easeInOut,
        ),
      ),
    );
    sizeStartBtn = TweenSequence<Size>(
      <TweenSequenceItem<Size>>[
        TweenSequenceItem<Size>(
          tween: Tween<Size>(
            begin: Size(Breakpoint.mobile, gapH52.height!),
            end: Size(gapW52.width!, gapH52.height!),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 80,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(gapW52.width!, gapH52.height!)),
          weight: 20,
        ),
        TweenSequenceItem<Size>(
          tween: Tween<Size>(
            begin: Size(gapW52.width!, gapH52.height!),
            end: Size.zero,
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 40,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: widget.controller.view,
        curve: const Interval(
          0.1,
          .5,
          curve: Curves.easeInOut,
        ),
      ),
    );
    sizePauseFinishBtn = TweenSequence<Size>(
      <TweenSequenceItem<Size>>[
        TweenSequenceItem<Size>(
          tween: Tween<Size>(
            begin: Size.zero,
            end: Size(gapW52.width!, gapH52.height!),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 40,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(gapW52.width!, gapH52.height!)),
          weight: 20,
        ),
        TweenSequenceItem<Size>(
          tween: Tween<Size>(
            begin: const Size(52, 52),
            end: Size(
              (Breakpoint.mobile - gapW16.width!) / 2,
              gapH52.height!,
            ),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 80,
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: widget.controller.view,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );
    opacityPauseFinishBtn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller.view,
        curve: const Interval(
          0.75,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  Future<void> onStartPressed() async {
    final result = await widget.onStart();
    if (result) {
      await widget.controller.forward();
    }
  }

  void onPauseResumePressed() {
    widget.onPause();
    setState(() {
      if (widget.timerState == TimerState.running) {
        btnPauseResumeText = btnResumeStr;
      } else {
        btnPauseResumeText = btnPauseStr;
      }
    });
  }

  void onFinishPressed() {
    widget.onFinish();
    widget.controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timerState == TimerState.running) {
      btnPauseResumeText = btnPauseStr;
    } else if (widget.timerState == TimerState.paused) {
      btnPauseResumeText = btnResumeStr;
    }
    return AnimatedBuilder(
      builder: (context, child) {
        return Stack(
          children: [
            Center(
              child: StandardButton(
                text: widget.btnStartLabel,
                width: sizeStartBtn.value.width,
                height: sizeStartBtn.value.height,
                opacitiy: opacityStartBtn.value,
                onPressed: onStartPressed,
              ),
            ),
            ResponsiveAlign(
              maxContentWidth: Breakpoint.mobile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: StandardButton(
                      text: btnPauseResumeText,
                      width: sizePauseFinishBtn.value.width,
                      height: sizePauseFinishBtn.value.height,
                      opacitiy: opacityPauseFinishBtn.value,
                      onPressed: onPauseResumePressed,
                    ),
                  ),
                  gapW16,
                  Center(
                    child: StandardButton(
                      text: widget.btnFinishLabel,
                      width: sizePauseFinishBtn.value.width,
                      height: sizePauseFinishBtn.value.height,
                      opacitiy: opacityPauseFinishBtn.value,
                      onPressed: onFinishPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      animation: widget.controller.view,
    );
  }
}
