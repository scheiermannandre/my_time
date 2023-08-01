import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';

/// The Loading state of the LabeledTimeFields.
class TextAndContainer extends StatelessWidget {
  /// Creates a TextAndContainer.
  const TextAndContainer({super.key, this.width, this.height, this.textWidth});

  /// The width of the container.
  final double? width;

  /// The width of the text.
  final double? textWidth;

  /// The height of the container.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final finalHeight = height ?? gapH48.height;
    final finalWidth = width ?? double.infinity;
    final finalTextWidth = textWidth ?? 50;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            color: Colors.grey,
            height: gapH24.height,
            width: finalTextWidth,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 12)),
        ResponsiveAlign(
          maxContentWidth: finalWidth,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              height: finalHeight,
            ),
          ),
        ),
      ],
    );
  }
}
