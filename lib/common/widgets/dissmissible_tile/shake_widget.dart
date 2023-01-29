import 'dart:math';

import 'package:flutter/material.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState();
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    this.shakeCount = 1,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeCount;
  final Duration shakeDuration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState() : super();
  late final animationController = AnimationController(vsync: this);
  @override
  void initState() {
    super.initState();
    animationController.duration = widget.shakeDuration;
    animationController.addStatusListener(_updateStatus);
    animationController.drive(CurveTween(curve: Curves.easeInOutBack));
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.rotate(
          angle: sineValue,
          child: child,
        );
      },
    );
  }
}
