import 'package:flutter/material.dart';
import 'package:my_time/config/theme/input_decoration_theme.dart';
import 'package:my_time/config/theme/primary_button_theme.dart';
import 'package:my_time/config/theme/secondary_button_theme.dart';
import 'package:my_time/config/theme/text_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';

/// The dark theme of the application.
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  textTheme: textTheme,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: DarkThemeColorTokens.primaryColor,
    onPrimary: Colors.white, //TBD
    secondary: Colors.white, //TBD
    onSecondary: Colors.white, //TBD
    error: DarkThemeColorTokens.errorColor,
    onError: Colors.white, //TBD
    background: DarkThemeColorTokens.darkestColor,
    onBackground: DarkThemeColorTokens.primaryColor, //TBD
    surface: DarkThemeColorTokens.darkestColor,
    onSurface: DarkThemeColorTokens.white,
  ),
  inputDecorationTheme: getInputDecorationTheme(
    LightThemeColorTokens.mediumColor,
    LightThemeColorTokens.errorColor,
  ),

  elevatedButtonTheme: PrimaryButtonThemeData.dark(),

  outlinedButtonTheme: SecondaryButtonThemeData.dark(),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: DarkThemeColorTokens.mediumColor,
  ),
  // This is needed
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
);
