import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_state.dart';

/// A widget that displays the timer action buttons.
class TimerActionButtons extends StatefulHookWidget {
  /// Creates a [TimerActionButtons].
  const TimerActionButtons({
    required this.start,
    required this.stop,
    required this.pause,
    required this.resume,
    required this.initialState,
    super.key,
  });

  /// The initial state of the timer.
  final TimerState initialState;

  /// The callback that is called to start the timer.
  final VoidCallback start;

  /// The callback that is called to stop the timer.
  final VoidCallback stop;

  /// The callback that is called to pause the timer.
  final VoidCallback pause;

  /// The callback that is called to resume the timer.
  final VoidCallback resume;
  @override
  State<TimerActionButtons> createState() => _TimerActionsState();
}

class _TimerActionsState extends State<TimerActionButtons>
    with SingleTickerProviderStateMixin {
  late TimerState state;
  late final AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
    );
    state = widget.initialState;

    if (state != TimerState.off) {
      controller.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton.iconWithBackground(
          context: context,
          child: Icon(
            state != TimerState.running
                ? Icons.play_arrow_outlined
                : Icons.pause_outlined,
          ),
          onPressed: () {
            setState(() {
              switch (state) {
                case TimerState.off:
                  state = TimerState.running;
                  controller.forward();
                  widget.start.call();
                case TimerState.running:
                  state = TimerState.paused;
                  widget.pause.call();
                case TimerState.paused:
                  state = TimerState.running;
                  widget.resume.call();
              }
            });
          },
        ),
        const SizedBox(
          width: SpaceTokens.medium,
        ).animate().custom(
          builder: (context, value, child) {
            return SizeTransition(
              sizeFactor: controller,
              axis: Axis.horizontal,
              child: child,
            );
          },
        ),
        ActionButton.iconWithBackground(
          context: context,
          child: const Icon(Icons.stop_outlined),
          onPressed: () {
            setState(() {
              state = TimerState.off;
              controller.reverse();
              widget.stop.call();
            });
          },
        ).animate().custom(
          builder: (context, value, child) {
            return AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: controller,
                  child: SizeTransition(
                    sizeFactor: controller,
                    axis: Axis.horizontal,
                    child: Transform.scale(
                      scale: controller.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: child,
            );
          },
        ),
      ],
    );
  }
}
