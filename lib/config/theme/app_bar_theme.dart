import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';

/// Defines the appearance of the application's app bar with
/// customizable themes.
class AppBarThemeData extends AppBarTheme {
  /// Constructs a [AppBarThemeData] for customizing app bar appearance.
  const AppBarThemeData({
    super.backgroundColor,
    super.foregroundColor,
    super.elevation,
    super.shadowColor,
    super.scrolledUnderElevation,
    super.centerTitle,
  });

  /// Constructs a light-themed [AppBarThemeData].
  factory AppBarThemeData.light() {
    return AppBarThemeData._getAppBarTheme(
      LightThemeColorTokens.lightestColor,
      LightThemeColorTokens.darkestColor,
      LightThemeColorTokens.lightColor,
    );
  }

  /// Constructs a dark-themed [AppBarThemeData].
  factory AppBarThemeData.dark() {
    return AppBarThemeData._getAppBarTheme(
      DarkThemeColorTokens.darkestColor,
      DarkThemeColorTokens.primaryColor,
      DarkThemeColorTokens.lightColor,
    );
  }

  /// Internal method for generating a [AppBarThemeData] with specified colors.
  factory AppBarThemeData._getAppBarTheme(
    Color backgroundColor,
    Color foregroundColor,
    Color shadowColor,
  ) {
    return AppBarThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shadowColor: shadowColor,
      elevation: 0,
      scrolledUnderElevation: .5,
      centerTitle: true,
    );
  }
}
