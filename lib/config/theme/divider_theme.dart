import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';

/// Defines the appearance of the application's cards.
class DividerTheming extends DividerThemeData {
  /// Constructs a [DividerTheming] for customizing card appearance.
  const DividerTheming({
    super.color,
    super.thickness,
    super.space,
  });

  /// Constructs a light-themed [DividerTheming].
  factory DividerTheming.light() {
    return DividerTheming._get(LightThemeColorTokens.mediumColor);
  }

  /// Constructs a dark-themed [DividerTheming].
  factory DividerTheming.dark() {
    return DividerTheming._get(DarkThemeColorTokens.mediumColor);
  }

  factory DividerTheming._get(Color color) {
    return DividerTheming(
      color: color,
      thickness: 1,
      space: 0,
    );
  }
}
