import 'dart:async';
import 'package:flutter/material.dart';

/// Widget that shows a child widget with a slide in animation.
class ShowUpWidget extends StatefulWidget {
  /// Constructor for the [ShowUpWidget].
  const ShowUpWidget({required this.child, super.key, this.delay = 0});

  /// Child widget to show.
  final Widget child;

  /// Delay before showing the widget.
  final int delay;

  @override
  ShowUpWidgetState createState() => ShowUpWidgetState();
}

/// The state of the [ShowUpWidget].
class ShowUpWidgetState extends State<ShowUpWidget>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(-0.1, 0), end: Offset.zero)
        .animate(curve);

    Timer(Duration(milliseconds: widget.delay), () {
      if (!mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
