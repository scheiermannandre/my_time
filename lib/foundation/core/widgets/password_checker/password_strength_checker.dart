import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_time/foundation/core/widgets/password_checker/password_checker.dart';

/// The widget that shows the password strength.
class PasswordStrengthChecker extends StatefulWidget {
  /// Creates a [PasswordStrengthChecker] widget.
  const PasswordStrengthChecker({
    required this.strength,
    super.key,
    this.configuration = const PasswordStrengthCheckerConfiguration(),
  });

  /// The [ValueNotifier] that contains the [PasswordStrength].
  final ValueNotifier<PasswordStrength?> strength;

  /// The object that keeps all the widget configuration.
  final PasswordStrengthCheckerConfiguration configuration;

  @override
  State<PasswordStrengthChecker> createState() =>
      _PasswordStrengthCheckerState();
}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    value: 0,
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.strength,
      builder: (_, currentStrength, __) {
        final statusWidget = currentStrength?.getStatusWidget(context);
        if (widget.configuration.showStatusWidget &&
            currentStrength!.enumValue != PasswordStrengthEnum.empty) {
          controller.forward();
        } else {
          controller.reverse();
        }
        return Column(
          children: [
            AnimatedContainer(
              duration: widget.configuration.animationDuration,
              curve: widget.configuration.animationCurve,
              height: widget.configuration.height,
              width: widget.configuration.width,
              alignment: widget.configuration.leftToRight
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: widget.configuration.externalBorderRadius,
                border: widget.configuration.hasBorder
                    ? Border.all(
                        color: widget.configuration.borderColor ??
                            currentStrength?.statusColor ??
                            widget.configuration.inactiveBorderColor,
                        width: widget.configuration.borderWidth,
                      )
                    : null,
              ),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: AnimatedContainer(
                      duration: widget.configuration.animationDuration,
                      curve: widget.configuration.animationCurve,
                      width: constraints.maxWidth *
                          (currentStrength?.widthPerc ?? 0),
                      decoration: BoxDecoration(
                        color: currentStrength?.statusColor,
                        borderRadius: widget.configuration.internalBorderRadius,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: widget.configuration.statusMargin,
              child: Row(
                mainAxisAlignment: widget.configuration.statusWidgetAlignment,
                children: [
                  statusWidget ?? const SizedBox.shrink(),
                ],
              ),
            ).animate().custom(
              builder: (context, value, child) {
                return SizeTransition(
                  sizeFactor: controller,
                  child: child,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
