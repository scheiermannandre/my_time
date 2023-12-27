import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';

/// A widget that displays a label and a list of widgets.
class LabeledWidgets extends StatelessWidget {
  /// Creates a [LabeledWidgets].
  const LabeledWidgets({
    required this.label,
    required this.children,
    super.key,
  });

  /// The label to display.
  final String label;

  /// The widgets to display.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SpaceTokens.small,
      children: [
        Text(
          label,
          style: TextStyleTokens.bodyMedium(null),
        ),
        ...children,
      ],
    );
  }
}
