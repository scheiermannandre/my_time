import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

/// A card with a label on top to display a setting.
class ShowValue extends StatelessWidget {
  /// Creates a [ShowValue].
  const ShowValue({
    required this.label,
    this.onTap,
    super.key,
    this.hint,
    this.data,
  });

  /// The label to display left inside the card.
  final String label;

  /// The data to display right inside the card.
  final String? data;

  /// An optional hint to display below the label.
  final String? hint;

  /// Called when the user taps this card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
              ),
              Row(
                children: [
                  if (data != null)
                    Text(
                      data!,
                      style: TextStyleTokens.bodyMedium(null),
                    ),
                  if (onTap != null)
                    const Column(
                      children: [
                        SizedBox(width: SpaceTokens.mediumSmall),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Icon(Icons.expand_more),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          if (hint != null)
            Text(
              hint!,
              style: TextStyleTokens.bodySmall(null)
                  .copyWith(color: ThemelessColorTokens.darkOrange),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
