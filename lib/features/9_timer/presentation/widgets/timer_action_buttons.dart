import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';

/// A widget that displays the timer action buttons.
class TimerActionButtons extends StatefulHookWidget {
  /// Creates a [TimerActionButtons].
  const TimerActionButtons({super.key});

  @override
  State<TimerActionButtons> createState() => _TimerActionsState();
}

class _TimerActionsState extends State<TimerActionButtons> {
  bool isPlaying = false;
  bool isOff = true;
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 100),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton.iconWithBackground(
          context: context,
          child: Icon(
            !isPlaying ? Icons.play_arrow_outlined : Icons.pause_outlined,
          ),
          onPressed: () {
            setState(() {
              if (!isPlaying && isOff) {
                isPlaying = true;
                isOff = false;
                controller.forward();
              } else if (isPlaying) {
                isPlaying = false;
              } else if (!isPlaying) {
                isPlaying = true;
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
              isPlaying = false;
              isOff = true;
              controller.reverse();
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
