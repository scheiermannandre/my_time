import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';

/// ThemeData to define the styling for snackbar.
class SnackBarTheme extends SnackBarThemeData {
  /// Constructs a [SnackBarTheme].
  const SnackBarTheme._({
    super.backgroundColor,
    super.shape,
    super.behavior,
    super.elevation,
  });

  /// Constructs a light theme for the snackbar.
  factory SnackBarTheme.light() {
    return SnackBarTheme._getSnackBarTheme(
      backgroundColor: LightThemeColorTokens.darkColor,
    );
  }

  /// Constructs a dark theme for the snackbar.
  factory SnackBarTheme.dark() {
    return SnackBarTheme._getSnackBarTheme(
      backgroundColor: DarkThemeColorTokens.lightestColor,
    );
  }

  /// Creates a [SnackBarTheme] instance with specified colors.
  factory SnackBarTheme._getSnackBarTheme({
    required Color backgroundColor,
  }) {
    return SnackBarTheme._(
      backgroundColor: backgroundColor,
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(CornerRadiusTokens.small),
        ),
      ),
    );
  }
}
