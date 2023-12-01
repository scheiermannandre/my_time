import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

/// A customizable notch widget typically used for indicating
/// selection or focus.
class Notch extends StatelessWidget {
  /// Creates a Notch widget.
  ///
  /// The [notchColor] parameter is the color of the notch.
  /// The [borderRadius] parameter is the border radius of the notch.
  /// The [height] parameter is the height of the notch.
  /// The [width] parameter is the width of the notch.
  /// The [padding] parameter is the padding around the notch.
  const Notch({
    required this.notchColor,
    this.borderRadius = CornerRadiusTokens.veryLarge,
    this.height = 6,
    this.width = 56,
    super.key,
    this.padding = const EdgeInsets.all(SpaceTokens.medium),
  });

  /// The color of the notch.
  final Color notchColor;

  /// The height of the notch.
  final double height;

  /// The width of the notch.
  final double width;

  /// The padding around the notch.
  final EdgeInsets padding;

  /// The border radius of the notch.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: notchColor,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
