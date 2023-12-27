import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

/// A widget for selecting a value from a list of options.
class ValueSelector extends StatefulWidget {
  /// Constructs a `ValueSelector` widget.
  ///
  /// - Parameters:
  ///   - `data`: The currently selected value.
  ///   - `onChoose`: A callback function triggered when a value is chosen.
  ///   - `options`: The list of available options.
  ///   - `horizontalPadding`: The horizontal padding around the widget.
  ///   - `labelText`: The optional label text displayed above the selector.
  const ValueSelector({
    required this.data,
    required this.onChoose,
    required this.options,
    this.horizontalPadding = SpaceTokens.medium,
    super.key,
    this.labelText,
  });

  /// The currently selected value.
  final String? data;

  /// The horizontal padding around the widget.
  final double horizontalPadding;

  /// The list of available options.
  final List<String> options;

  /// The optional label text displayed above the selector.
  final String? labelText;

  /// A callback function triggered when a value is chosen.

  final void Function(String option) onChoose;

  @override
  State<ValueSelector> createState() => _ValueSelectorState();
}

class _ValueSelectorState extends State<ValueSelector> {
  final IconData _iconData = Icons.check;
  String? chosenOption;

  @override
  void initState() {
    chosenOption = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = ThemeColorBuilder(context).getGuidingIconColor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
          ),
        if (widget.labelText != null)
          const SizedBox(
            height: SpaceTokens.verySmall,
          ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final option = widget.options[index];
            return ListTile(
              title: Text(option),
              trailing: chosenOption == option
                  ? Icon(_iconData, color: iconColor)
                  : null,
              onTap: () => _onPressed(option),
            );
          },
        ),
      ],
    );
  }

  /// Handles the selection of an option.
  void _onPressed(String option) {
    setState(() {
      chosenOption = option;
    });

    widget.onChoose(chosenOption!);
  }
}
