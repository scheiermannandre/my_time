import 'package:flutter/material.dart';
import 'package:my_time/config/theme/app_bar_theme.dart';
import 'package:my_time/config/theme/buttom_sheet_theme.dart';
import 'package:my_time/config/theme/card_theme.dart';
import 'package:my_time/config/theme/input_decoration_theme.dart';
import 'package:my_time/config/theme/list_tile_theme.dart';
import 'package:my_time/config/theme/primary_button_theme.dart';
import 'package:my_time/config/theme/secondary_button_theme.dart';
import 'package:my_time/config/theme/snackbar_theme.dart';
import 'package:my_time/config/theme/switch_theme_data.dart';
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
    onPrimary: LightThemeColorTokens.darkColor,
    secondary: LightThemeColorTokens.mediumColor,
    onSecondary: Colors.white, //TBD
    tertiary: LightThemeColorTokens.mediumColor,
    error: LightThemeColorTokens.errorColor,
    onError: Colors.white, //TBD
    background: LightThemeColorTokens.lightestColor,
    onBackground: LightThemeColorTokens.black,
    surface: LightThemeColorTokens.white,
    onSurface: LightThemeColorTokens.black,
    surfaceTint: Colors.transparent, // removes color blur on dialog background
    shadow: LightThemeColorTokens.mediumColor,
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
  bottomSheetTheme: ButtomSheetTheme.light(),
  listTileTheme: TileTheme.light(),
  cardTheme: CardThemeData.light(),
  switchTheme: AppSwitchTheme.light(),
);
