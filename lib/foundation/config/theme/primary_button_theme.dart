import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

/// ThemeData to define the styling for primary buttons across the app.
class PrimaryButtonThemeData extends ElevatedButtonThemeData {
  /// Constructs a [PrimaryButtonThemeData].
  const PrimaryButtonThemeData._({
    super.style,
  });

  /// Constructs a light theme for primary buttons.
  factory PrimaryButtonThemeData.light() {
    return PrimaryButtonThemeData._getPrimaryBtnTheme(
      foregroundColor: LightThemeColorTokens.black,
      backgroundColor: LightThemeColorTokens.primaryColor,
      borderColor: LightThemeColorTokens.black,
    );
  }

  /// Constructs a dark theme for primary buttons.
  factory PrimaryButtonThemeData.dark() {
    return PrimaryButtonThemeData._getPrimaryBtnTheme(
      foregroundColor: DarkThemeColorTokens.black,
      backgroundColor: DarkThemeColorTokens.primaryColor,
      borderColor: DarkThemeColorTokens.primaryColor,
    );
  }

  /// Creates a [PrimaryButtonThemeData] instance with specified colors.
  factory PrimaryButtonThemeData._getPrimaryBtnTheme({
    required Color foregroundColor,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return PrimaryButtonThemeData._(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: SpaceTokens.medium,
          vertical: SpaceTokens.mediumSmall,
        ),
        shadowColor: Colors.transparent,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: foregroundColor.withOpacity(0.8),
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
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
