import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// A widget that shows a value in a review step.
class ReviewLabeldDataValue extends StatelessWidget {
  /// Constructor for the ShowReviewValue widget.
  const ReviewLabeldDataValue({
    required this.label,
    required this.data,
    super.key,
  });

  /// The label of the value.
  final String label;

  /// The data of the value.
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
        ),
        Text(
          data,
          style: TextStyleTokens.bodyMedium(null),
        ),
      ],
    );
  }
}

/// A widget that shows a value in a review step.
class ReviewDataValue extends StatelessWidget {
  /// Constructor for the ShowReviewValue widget.
  const ReviewDataValue({
    required this.label,
    super.key,
  });

  /// The label of the value.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, textAlign: TextAlign.start);
  }
}
