import 'package:flutter/material.dart';

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

  /// Used for heading text.
  static const white = ThemelessColorTokens.white;

  /// Used for heading text.
  static const black = ThemelessColorTokens.black;

  /// Used for error messages.
  static const errorColor = ThemelessColorTokens.red;
}

/// A class that provides the color tokens for the dark theme.
class DarkThemeColorTokens {
  /// Used for actions.
  static const primaryColor = Color(0xFFFADEB4);

  /// Used for heading text.
  static const white = ThemelessColorTokens.white;

  /// Used for heading text.
  static const black = ThemelessColorTokens.black;

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
  static const errorColor = ThemelessColorTokens.red;
}

/// A class that provides the color tokens that are independet of the theme.
class ThemelessColorTokens {
  /// White
  static const white = Color(0xFFFFFFFF);

  /// Black
  static const black = Color(0xFF000000);

  /// Red
  static const red = Color(0xffF11919);

  /// DarkOrange
  static const darkOrange = Color(0xffF9856D);

  /// lightOrange
  static const lightOrange = Color(0xffF49B1E);

  /// Yellow
  static const yellow = Color(0xffF4DE1E);

  /// lightGreen
  static const lightGreen = Color(0xffA8E234);

  /// Green
  static const green = Color(0xff52CC15);
}

/// A class that provides Colors based on the current [ThemeMode].
class ThemeColorBuilder {
  /// Constructs a [ThemeColorBuilder].
  ThemeColorBuilder(this._context);

  final BuildContext _context;

  /// Returns the color for non-decorative borders depending on
  /// the [Brightness].
  ///
  /// For [Brightness.light], returns [LightThemeColorTokens.mediumColor].
  /// For [Brightness.dark], returns [DarkThemeColorTokens.lightColor].
  Color getNonDecorativeBorderColor() {
    switch (Theme.of(_context).brightness) {
      case Brightness.light:
        return LightThemeColorTokens.mediumColor;
      case Brightness.dark:
        return DarkThemeColorTokens.lightColor;
    }
  }

  /// Returns the color for icons that are not on primary depending on
  /// the [Brightness].
  ///
  /// For [Brightness.light], returns [LightThemeColorTokens.darkColor].
  /// For [Brightness.dark], returns [DarkThemeColorTokens.lightestColor].
  Color getIconColor() {
    switch (Theme.of(_context).brightness) {
      case Brightness.light:
        return LightThemeColorTokens.darkColor;
      case Brightness.dark:
        return DarkThemeColorTokens.lightestColor;
    }
  }

  /// Returns the color for actions depending on the [Brightness].
  /// Can be referred to as the primary color.
  ///
  /// For [Brightness.light], returns [LightThemeColorTokens.primaryColor].
  /// For [Brightness.dark], returns [DarkThemeColorTokens.primaryColor].
  Color getActionsColor() {
    switch (Theme.of(_context).brightness) {
      case Brightness.light:
        return LightThemeColorTokens.primaryColor;
      case Brightness.dark:
        return DarkThemeColorTokens.primaryColor;
    }
  }

  /// Returns the color for icon that are displayed on list tile
  /// depending on the [Brightness].
  /// Can be referred to as the primary color.
  ///
  /// For [Brightness.light], returns [LightThemeColorTokens.darkColor].
  /// For [Brightness.dark], returns [DarkThemeColorTokens.primaryColor].
  Color getGuidingIconColor() {
    switch (Theme.of(_context).brightness) {
      case Brightness.light:
        return LightThemeColorTokens.darkColor;
      case Brightness.dark:
        return DarkThemeColorTokens.primaryColor;
    }
  }
}
