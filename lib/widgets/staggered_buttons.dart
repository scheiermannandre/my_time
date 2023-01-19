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
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(500, 50), end: Size(50.0, 50))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 80.0,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(50.0, 50)),
          weight: 20.0,
        ),
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
        TweenSequenceItem<Size>(
          tween: Tween<Size>(begin: Size(0, 0), end: Size(50, 50))
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
        TweenSequenceItem<Size>(
          tween: ConstantTween<Size>(Size(50, 50)),
          weight: 20.0,
        ),
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

  Widget _buildButton(double width, double height, double opacity, String text,
      Function onPressed) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12.5),
          backgroundColor: GlobalProperties.SecondaryAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: _buildText(opacity, text),
      ),
    );
  }

  Widget _buildText(double opacity, String text) {
    return Opacity(
      opacity: opacity,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: GlobalProperties.TextAndIconColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.fade,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildButton(size.value.width, size.value.height, opacity.value,
            "Start", onStartPressed),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(size2.value.width, size2.value.height, opacity1.value,
                btnPauseResumeText, onPauseResumePressed),
            _buildButton(size2.value.width, size2.value.height, opacity1.value,
                "Finish", onFinishPressed),
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
