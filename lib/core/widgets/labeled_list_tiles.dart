import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// A widget that displays a labeled list of items.
///
/// The [LabeledListTiles] widget is used to display a list of items with
/// a label.
/// It provides options to show icons for each item and handle empty lists.

class LabeledListTiles extends StatelessWidget {
  /// Constructor to build the [LabeledListTiles] widget.
  const LabeledListTiles({
    required this.label,
    required this.items,
    super.key,
    this.emptyListLabel = '',
    this.showIcons = true,
  });

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
          Visibility(
            visible: items.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: SpaceTokens.mediumSmall),
              child: Text(
                emptyListLabel,
              ),
            ),
          ),
          Visibility(
            visible: items.isNotEmpty,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(items[index]),
                  onTap: () => Navigator.of(context).pop(index),
                  trailing: showIcons
                      ? RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.expand_more,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : null,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: SpaceTokens.verySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
