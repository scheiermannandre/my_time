import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';

/// Defines the appearance of the application's cards.
class CardThemeData extends CardTheme {
  /// Constructs a [CardThemeData] for customizing card appearance.
  const CardThemeData({
    super.margin,
    super.shape,
    super.shadowColor,
  });

  /// Constructs a light-themed [CardThemeData].
  factory CardThemeData.light() {
    return CardThemeData._get(LightThemeColorTokens.mediumColor);
  }

  /// Constructs a dark-themed [CardThemeData].
  factory CardThemeData.dark() {
    return CardThemeData._get(DarkThemeColorTokens.mediumColor);
  }

  factory CardThemeData._get(Color borderColor) {
    return CardThemeData(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(CornerRadiusTokens.small),
      ),
      shadowColor: Colors.transparent,
    );
  }
}
