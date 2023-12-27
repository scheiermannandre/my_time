import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/wizard/labeled_widgets.dart';

/// A card with a label on top to display a setting.
class SettingsBlock extends StatelessWidget {
  /// Creates a [SettingsBlock].
  const SettingsBlock({
    required this.children,
    required this.label,
    super.key,
  });

  /// The widgets to display inside the card.
  final List<Widget> children;

  /// The label to display on top of the card.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpaceTokens.mediumSmall),
      child: LabeledWidgets(
        label: label,
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
