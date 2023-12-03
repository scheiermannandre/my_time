import 'package:flutter/material.dart';
import 'package:my_time/config/theme/app_bar_theme.dart';
import 'package:my_time/config/theme/input_decoration_theme.dart';
import 'package:my_time/config/theme/primary_button_theme.dart';
import 'package:my_time/config/theme/secondary_button_theme.dart';
import 'package:my_time/config/theme/snackbar_theme.dart';
import 'package:my_time/config/theme/tertiary_button_theme.dart';
import 'package:my_time/config/theme/text_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';

/// The light theme of the application.
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: textTheme,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: LightThemeColorTokens.primaryColor,
    onPrimary: Colors.white, //TBD
    secondary: Colors.white, //TBD
    onSecondary: Colors.white, //TBD
    error: LightThemeColorTokens.errorColor,
    onError: Colors.white, //TBD
    background: LightThemeColorTokens.lightestColor,
    onBackground: LightThemeColorTokens.black, //TBD
    surface: LightThemeColorTokens.white,
    onSurface: LightThemeColorTokens.black,
    surfaceTint: Colors.transparent, // removes color blur on dialog background
  ),

  inputDecorationTheme: getInputDecorationTheme(
    LightThemeColorTokens.mediumColor,
    LightThemeColorTokens.errorColor,
  ),
  elevatedButtonTheme: PrimaryButtonThemeData.light(),
  outlinedButtonTheme: SecondaryButtonThemeData.light(),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.zero,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        LightThemeColorTokens.darkColor,
      ),
    ),
  ),
  textButtonTheme: TertiaryButtonThemeData.light(),
  snackBarTheme: SnackBarTheme.light(),
  appBarTheme: AppBarThemeData.light(),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: LightThemeColorTokens.mediumColor,
  ),

  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: LightThemeColorTokens.mediumColor,
  ),
  // This is needed
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
);