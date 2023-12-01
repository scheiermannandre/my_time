import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/mighty_splash_list_tile.dart';

/// A widget that displays a labeled list of items.
///
/// The [MightyLabeledList] widget is used to display a list of items with
/// a label.
/// It provides options to show icons for each item and handle empty lists.
///
/// Example usage:
///
/// ```dart
/// MightyLabeledList(
///   themeController: MightyThemeController(),
///   label: 'Fruits',
///   items: ['Apple', 'Banana', 'Orange'],
///   emptyListLabel: 'No fruits available',
///   showIcons: true,
/// )
/// ```
class MightyLabeledList extends StatelessWidget {
  /// Constructor to build the [MightyLabeledList] widget.
  const MightyLabeledList({
    required this.themeController,
    required this.label,
    required this.items,
    super.key,
    this.emptyListLabel = '',
    this.showIcons = true,
  });

  /// The [themeController] is used to customize the appearance of the list.

  final MightyThemeController themeController;

  /// The [label] is the text to display as the label for the list.
  final String label;

  /// The [emptyListLabel] is the text to display when the list is empty.
  final String emptyListLabel;

  /// The [items] is the list of strings to display as the items in the list.
  final List<String> items;

  /// The [showIcons] determines whether to show icons for each item.
  final bool showIcons;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SpaceTokens.medium,
        right: SpaceTokens.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyleTokens.getHeadline5(null),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: SpaceTokens.mediumSmall),
              child: Text(
                emptyListLabel,
              ),
            )
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return MightySplashListTile(
                  themeController: themeController,
                  text: items[index],
                  showIcon: showIcons,
                  onPressed: () => Navigator.of(context).pop(index),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: SpaceTokens.verySmall,
              ),
            ),
        ],
      ),
    );
  }
}
