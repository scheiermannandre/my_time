import 'package:flutter/material.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/size_tokens.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/spaced_row.dart';

/// A widget representing an individual step indicator in a step indicator row.
///
/// The `StepIndicator` widget displays a visual representation of a step
/// in a step-by-step process. It can be either active or inactive, and its
/// appearance is defined by the `StepIndicatorStyle`.
class StepIndicator extends StatelessWidget {
  /// Creates a `StepIndicator` widget.
  ///
  /// The [isActive] parameter indicates whether the step is active or not.
  /// The [style] parameter defines the visual style of the step indicator.
  const StepIndicator({
    required this.isActive,
    required this.style,
    super.key,
  });

  /// Indicates whether the step is active or not.
  final bool isActive;

  /// The visual style of the step indicator.
  final StepIndicatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.borderRadius),
          color: isActive ? style.activeColor : style.inactiveColor,
        ),
        height: style.height,
        width: style.width,
      ),
    );
  }
}

/// Defines the visual style of a `StepIndicator`.
///
/// The `StepIndicatorStyle` class is used to customize the appearance
/// of a `StepIndicator`. It includes properties such as colors, border radius,
/// height, and width.
class StepIndicatorStyle {
  /// Creates a `StepIndicatorStyle`.
  ///
  /// The [activeColor] is the color used for an active step indicator.
  /// The [inactiveColor] is the color used for an inactive step indicator.
  /// The [borderRadius] specifies the border radius of the step indicator.
  /// The [height] is the height of the step indicator.
  /// The [width] is the width of the step indicator, which can be null for
  /// a default width.
  const StepIndicatorStyle({
    required this.activeColor,
    required this.inactiveColor,
    this.borderRadius = CornerRadiusTokens.small,
    this.height = SizeTokens.x8,
    this.width,
  });

  /// The color used for an active step indicator.
  final Color activeColor;

  /// The color used for an inactive step indicator.
  final Color inactiveColor;

  /// The border radius of the step indicator.
  final double borderRadius;

  /// The height of the step indicator.
  final double height;

  /// The width of the step indicator. It can be null for a default width.
  final double? width;
}

/// A row of step indicators representing the progress of a multi-step process.
///
/// The `StepIndicatorRow` widget displays a row of step indicators, each
/// representing a step in a multi-step process. The current step is indicated
/// by the [currentStep] parameter, and the total number of steps is specified
/// by the [steps] parameter. The appearance of the step indicators is defined
/// by the [stepStyle] parameter, and spacing between the indicators can be
/// customized using the [spacing] parameter.
class StepIndicatorRow extends StatelessWidget {
  /// Creates a `StepIndicatorRow` widget.
  ///
  /// The [currentStep] parameter specifies the current step in the process.
  /// The [steps] parameter indicates the total number of steps.
  /// The [stepStyle] parameter defines the visual style of the step indicators.
  /// The [spacing] parameter sets the spacing between the step indicators.
  const StepIndicatorRow({
    required this.currentStep,
    required this.steps,
    required this.stepStyle,
    super.key,
    this.spacing = SpaceTokens.medium,
  });

  /// The current step in the multi-step process.
  final int currentStep;

  /// The total number of steps in the multi-step process.
  final int steps;

  /// The visual style of the step indicators.
  final StepIndicatorStyle stepStyle;

  /// The spacing between the step indicators.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      spacing: spacing,
      children: List.generate(
        steps,
        (index) => StepIndicator(
          isActive: index <= currentStep,
          style: stepStyle,
        ),
      ),
    );
  }
}
