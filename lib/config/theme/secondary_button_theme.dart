import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// ThemeData to define the styling for secondary buttons across the app.
class SecondaryButtonThemeData extends OutlinedButtonThemeData {
  /// Constructs a [SecondaryButtonThemeData].
  const SecondaryButtonThemeData._({
    super.style,
  });

  /// Constructs a light theme for secondary buttons.
  factory SecondaryButtonThemeData.light() {
    return SecondaryButtonThemeData._getSecondaryBtnTheme(
      foregroundColor: LightThemeColorTokens.black,
      backgroundColor: LightThemeColorTokens.white,
      borderColor: LightThemeColorTokens.black,
    );
  }

  /// Constructs a dark theme for secondary buttons.
  factory SecondaryButtonThemeData.dark() {
    return SecondaryButtonThemeData._getSecondaryBtnTheme(
      foregroundColor: DarkThemeColorTokens.lightestColor,
      backgroundColor: DarkThemeColorTokens.darkestColor,
      borderColor: DarkThemeColorTokens.primaryColor,
    );
  }

  /// Creates a [SecondaryButtonThemeData] instance with specified colors.
  factory SecondaryButtonThemeData._getSecondaryBtnTheme({
    required Color foregroundColor,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return SecondaryButtonThemeData._(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        disabledBackgroundColor: Colors.grey.withOpacity(0.12),
        textStyle: TextStyleTokens.body(null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CornerRadiusTokens.small),
        ),
        side: BorderSide(
          color: borderColor,
        ),
      ),
    );
  }
}
