import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

/// A custom divider with text in the middle.
class TextDivider extends StatelessWidget {
  /// Constructs a `TextDivider` widget.
  ///
  /// - Parameters:
  ///   - `dividerColor`: The color of the divider.
  ///   - `dividerText`: The widget to be displayed at the center of the
  ///      divider.
  ///   - `dividerThickness`: The thickness of the divider line.
  ///   - `horizontalPadding`: The horizontal padding around the divider.
  const TextDivider({
    required this.dividerColor,
    required this.dividerText,
    this.dividerThickness = 1,
    this.horizontalPadding = 16,
    super.key,
  });

  /// The color of the divider.
  final Color dividerColor;

  /// The thickness of the divider line.
  final double dividerThickness;

  /// The widget to be displayed at the center of the divider.
  final Widget dividerText;

  /// The horizontal padding around the divider.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: dividerThickness,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.small),
            child: dividerText,
          ),
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: dividerThickness,
            ),
          ),
        ],
      ),
    );
  }
}
