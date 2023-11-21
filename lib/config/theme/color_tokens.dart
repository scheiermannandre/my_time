import 'dart:ui';

import 'package:my_time/config/theme/mighty_theme.dart';

/// [ThemeColors] is a class that provides the colors for the app depending
/// on the [SystemThemeMode].
class ThemeColors {
  /// Returns the color for actions depending on the [SystemThemeMode].
  /// Can be referred to as the primary color.
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.primaryColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.primaryColor].
  static Color getActionsColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.primaryColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.primaryColor;
    }
  }

  /// Returns the color for heading text depending on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.darkestColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.white].
  static Color getHeadingTextColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.darkestColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.white;
    }
  }

  /// Returns the color for secondary text depending on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.darkColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.lightestColor].
  static Color getSecondaryTextColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.darkColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.lightestColor;
    }
  }

  /// Returns the color for non-decorative borders depending on
  /// the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.mediumColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.lightColor].
  static Color getNonDecorativeBorderColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.mediumColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.lightColor;
    }
  }

  /// Returns the error color depending on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.errorColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.errorColor].
  static Color getErrorColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.errorColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.errorColor;
    }
  }

  /// Returns the color for decorative borders depending
  /// on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.lightColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.mediumColor].
  static Color getDecorativeBorderColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.lightColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.mediumColor;
    }
  }

  /// Returns the alternate background color depending on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light],
  /// returns [LightThemeColorTokens.lightestColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.darkColor].
  static Color getAlternateBackgroundColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.lightestColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.darkColor;
    }
  }

  /// Returns the main background color depending on the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light],
  /// returns [LightThemeColorTokens.lightestColor].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.darkestColor].
  static Color getMainBackgroundColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.lightestColor;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.darkestColor;
    }
  }

  /// Returns the color to use on background color depending on
  /// the [SystemThemeMode].
  ///
  /// For [SystemThemeMode.light], returns [LightThemeColorTokens.white].
  /// For [SystemThemeMode.dark], returns [DarkThemeColorTokens.darkestColor].
  static Color getOnBackgroundColor(SystemThemeMode mode) {
    switch (mode) {
      case SystemThemeMode.light:
        return LightThemeColorTokens.white;
      case SystemThemeMode.dark:
        return DarkThemeColorTokens.darkestColor;
    }
  }
}

/// A class that provides the color tokens for the light theme.
class LightThemeColorTokens {
  /// Used for actions.
  static const primaryColor = Color(0xFFFADEB4);

  /// Used for heading text.
  static const darkestColor = Color(0xFF171717);

  /// Used for secondary text.
  static const darkColor = Color(0xFF414141);

  /// Used for non-decorative borders.
  static const mediumColor = Color(0xFF808080);

  /// Used for decorative borders.
  static const lightColor = Color(0xFFE0E0E0);

  /// Used for alternate backgrounds.
  static const lightestColor = Color(0xFFF5F5F5);

  /// Used for main backgrounds.
  static const white = Color(0xFFFFFFFF);

  /// Used for heading text.
  static const black = Color(0xFF000000);

  /// Used for error messages.
  static const errorColor = Color(0xFFF03D3E);
}

/// A class that provides the color tokens for the dark theme.
class DarkThemeColorTokens {
  /// Used for actions.
  static const primaryColor = Color(0xFFFADEB4);

  /// Used for heading text.
  static const white = Color(0xFFFFFFFF);

  /// Used for heading text.
  static const black = Color(0xFF000000);

  /// Used for secondary text.
  static const lightestColor = Color(0xFFF5F5F5);

  /// Used for non-decorative borders.
  static const lightColor = Color(0xFFE0E0E0);

  /// Used for decorative borders.
  static const mediumColor = Color(0xFF808080);

  /// Used for alternate backgrounds.
  static const darkColor = Color(0xFF535353);

  /// Used for main backgrounds.
  static const darkestColor = Color(0xFF414141);

  /// Used for error messages.
  static const errorColor = Color(0xFFF03D3E);
}
