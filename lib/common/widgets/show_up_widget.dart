import 'dart:async';

import 'package:flutter/material.dart';

class ShowUpWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const ShowUpWidget({super.key, required this.child, this.delay = 0});

  @override
  ShowUpWidgetState createState() => ShowUpWidgetState();
}

class ShowUpWidgetState extends State<ShowUpWidget>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(-0.1, 0.0), end: Offset.zero)
            .animate(curve);

    Timer(Duration(milliseconds: widget.delay), () {
      _animController.forward();
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
