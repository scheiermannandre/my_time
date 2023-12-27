import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

/// ThemeData to define the styling for tertiary buttons across the app.
class TertiaryButtonThemeData extends TextButtonThemeData {
  /// Constructs a [TertiaryButtonThemeData].
  const TertiaryButtonThemeData._({
    super.style,
  });

  /// Constructs a light theme for tertiary buttons.
  factory TertiaryButtonThemeData.light() {
    return TertiaryButtonThemeData._getTertiaryBtnTheme(
      foregroundColor: LightThemeColorTokens.darkColor,
    );
  }

  /// Constructs a dark theme for tertiary buttons.
  factory TertiaryButtonThemeData.dark() {
    return TertiaryButtonThemeData._getTertiaryBtnTheme(
      foregroundColor: DarkThemeColorTokens.primaryColor,
    );
  }

  /// Creates a [TertiaryButtonThemeData] instance with specified colors.
  factory TertiaryButtonThemeData._getTertiaryBtnTheme({
    required Color foregroundColor,
  }) {
    return TertiaryButtonThemeData._(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyleTokens.body(null),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: SpaceTokens.mediumSmall,
            vertical: SpaceTokens.verySmall,
          ),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CornerRadiusTokens.small,
            ),
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          foregroundColor,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          foregroundColor.withOpacity(0.1),
        ),
      ),
    );
  }
}
