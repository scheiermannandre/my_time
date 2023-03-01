import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/standard_button.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/constants/breakpoints.dart';

class StaggeredButtons extends StatefulWidget {
  final Function onStart;
  final Function onFinish;
  final Function onPause;
  final AnimationController controller;
  late bool timerIsActive;
  StaggeredButtons(
      {super.key,
      required this.onStart,
      required this.onFinish,
      required this.onPause,
      required this.controller,
      required this.timerIsActive});

  @override
  State<StaggeredButtons> createState() => _StaggeredButtonsState();
}

class _StaggeredButtonsState extends State<StaggeredButtons>
    with TickerProviderStateMixin {
  late Animation<Size> sizeStartBtn;
  late Animation<double> opacityStartBtn;
  late Animation<Size> sizePauseFinishBtn;
  late Animation<double> opacityPauseFinishBtn;

  @override
  void initState() {
    super.initState();
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
                  begin:  Size(Breakpoint.mobile, gapH52.height!),
                  end: Size(gapW52.width!, gapH52.height!))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 80.0,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(gapW52.width!, gapH52.height!)),
          weight: 20.0,
        ),
        TweenSequenceItem<Size>(
          tween:
              Tween<Size>(begin: Size(gapW52.width!, gapH52.height!), end: const Size(0, 0))
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
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
          tween:
              Tween<Size>(begin: const Size(0, 0), end: Size(gapW52.width!, gapH52.height!))
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(gapW52.width!, gapH52.height!)),
          weight: 20.0,
        ),
        TweenSequenceItem<Size>(
          tween: Tween<Size>(
                  begin: const Size(52, 52),
                  end: Size((Breakpoint.mobile - gapW16.width!) / 2, gapH52.height!))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 80.0,
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

  @override
  void dispose() {
    super.dispose();
  }

  String btnPauseStr = "Pause";
  String btnResumeStr = "Resume";
  String btnPauseResumeText = "Pause";

  void onStartPressed() {
    widget.onStart();
    widget.controller.forward();
  }

  void onPauseResumePressed() {
    setState(() {
      if (widget.timerIsActive) {
        btnPauseResumeText = btnResumeStr;
      } else {
        btnPauseResumeText = btnPauseStr;
      }
    });
    widget.onPause();
  }

  void onFinishPressed() {
    widget.onFinish();
    widget.controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: ((context, child) {
        return Stack(
          children: [
            Center(
              child: StandardButton(
                text: "Start",
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
                      text: "Finish",
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
      }),
      animation: widget.controller.view,
    );
  }
}
