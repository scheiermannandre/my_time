import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

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
  late Animation<Size> size;
  late Animation<double> opacity;
  late Animation<Size> size2;
  late Animation<double> opacity1;

  @override
  void initState() {
    super.initState();

    opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: widget.controller.view,
        curve: const Interval(
          0,
          .25,
          curve: Curves.easeInOut,
        ),
      ),
    );
    size = TweenSequence<Size>(
      <TweenSequenceItem<Size>>[
        // Animate from .5 to 1 in the first 40/80th of this animation
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(500, 50), end: Size(50.0, 50))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 80.0,
        ),
        // Maintain still at 1.0 for 20/80th
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(50.0, 50)),
          weight: 20.0,
        ),
        // Animate back from 1 to 0.5 for the last 40/80th
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(50.0, 50), end: Size(0, 0))
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
    size2 = TweenSequence<Size>(
      <TweenSequenceItem<Size>>[
        // Animate from .5 to 1 in the first 40/80th of this animation
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(0, 0), end: Size(50, 50))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
        // Maintain still at 1.0 for 20/80th
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(50, 50)),
          weight: 20.0,
        ),
        // Animate back from 1 to 0.5 for the last 40/80th
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(50, 50), end: Size(125, 50))
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
    opacity1 = Tween<double>(begin: 0, end: 1).animate(
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
// This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          //alignment: Alignment.center,
          width: size.value.width,
          height: size.value.height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12.5),
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            onPressed: () {
              widget.onStart();
              widget.controller.forward();
            },
            child: Opacity(
              opacity: opacity.value,
              child: const Text(
                "Start",
                style: TextStyle(
                    fontSize: 16, color: GlobalProperties.TextAndIconColor),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: size2.value.width,
              height: size2.value.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.5),
                  backgroundColor: GlobalProperties.SecondaryAccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (widget.timerIsActive) {
                      btnPauseResumeText = btnResumeStr;
                    } else {
                      btnPauseResumeText = btnPauseStr;
                    }
                  });
                  widget.onPause();
                },
                child: Opacity(
                  opacity: opacity1.value,
                  child: Text(
                    btnPauseResumeText,
                    style: TextStyle(
                        fontSize: 16, color: GlobalProperties.TextAndIconColor),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size2.value.width,
              height: size2.value.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.5),
                  backgroundColor: GlobalProperties.SecondaryAccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                onPressed: () {
                  widget.onFinish();
                  widget.controller.reverse();
                },
                child: Opacity(
                  opacity: opacity1.value,
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                        fontSize: 16, color: GlobalProperties.TextAndIconColor),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AnimatedBuilder(
        builder: _buildAnimation,
        animation: widget.controller.view,
      ),
    );
  }
}
