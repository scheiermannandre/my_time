import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_splash_list_tile.dart';

/// A widget for selecting a value from a list of options.
class ValueSelector extends StatefulWidget {
  /// Constructs a `ValueSelector` widget.
  ///
  /// - Parameters:
  ///   - `themeController`: The controller managing the theme of the widget.
  ///   - `data`: The currently selected value.
  ///   - `onChoose`: A callback function triggered when a value is chosen.
  ///   - `options`: The list of available options.
  ///   - `horizontalPadding`: The horizontal padding around the widget.
  ///   - `labelText`: The optional label text displayed above the selector.
  const ValueSelector({
    required this.themeController,
    required this.data,
    required this.onChoose,
    required this.options,
    this.horizontalPadding = SpaceTokens.medium,
    super.key,
    this.labelText,
  });

  /// The controller managing the theme of the widget.
  final MightyThemeController themeController;

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Text(
              widget.labelText!,
              style: widget.themeController.small,
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
              return MightySplashListTile(
                themeController: widget.themeController,
                text: option,
                showIcon: chosenOption == option,
                iconData: _iconData,
                onPressed: () => _onPressed(option),
              );
            },
          ),
        ],
      ),
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
