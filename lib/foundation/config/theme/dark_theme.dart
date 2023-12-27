import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/app_bar_theme.dart';
import 'package:my_time/foundation/config/theme/buttom_sheet_theme.dart';
import 'package:my_time/foundation/config/theme/card_theme.dart';
import 'package:my_time/foundation/config/theme/divider_theme.dart';
import 'package:my_time/foundation/config/theme/input_decoration_theme.dart';
import 'package:my_time/foundation/config/theme/list_tile_theme.dart';
import 'package:my_time/foundation/config/theme/primary_button_theme.dart';
import 'package:my_time/foundation/config/theme/secondary_button_theme.dart';
import 'package:my_time/foundation/config/theme/snackbar_theme.dart';
import 'package:my_time/foundation/config/theme/switch_theme_data.dart';
import 'package:my_time/foundation/config/theme/tertiary_button_theme.dart';
import 'package:my_time/foundation/config/theme/text_theme.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';

/// The dark theme of the application.
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  textTheme: textTheme,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: DarkThemeColorTokens.primaryColor,
    onPrimary: DarkThemeColorTokens.darkestColor,
    secondary: DarkThemeColorTokens.primaryColor,
    onSecondary: Colors.white, //TBD
    tertiary: DarkThemeColorTokens.mediumColor,
    error: DarkThemeColorTokens.errorColor,
    onError: Colors.white, //TBD
    background: DarkThemeColorTokens.darkestColor,
    onBackground: DarkThemeColorTokens.lightestColor,
    surface: DarkThemeColorTokens.darkestColor,
    onSurface: DarkThemeColorTokens.white,
    surfaceTint: Colors.transparent, // removes color blur on dialog background
    shadow: DarkThemeColorTokens.mediumColor,
  ),
  inputDecorationTheme: getInputDecorationTheme(
    DarkThemeColorTokens.mediumColor,
    DarkThemeColorTokens.errorColor,
  ),
  elevatedButtonTheme: PrimaryButtonThemeData.dark(),
  outlinedButtonTheme: SecondaryButtonThemeData.dark(),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        DarkThemeColorTokens.lightestColor,
      ),
    ),
  ),
  textButtonTheme: TertiaryButtonThemeData.dark(),
  snackBarTheme: SnackBarTheme.dark(),
  appBarTheme: AppBarThemeData.dark(),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: DarkThemeColorTokens.mediumColor,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: DarkThemeColorTokens.primaryColor,
  ),
  bottomSheetTheme: ButtomSheetTheme.dark(),
  listTileTheme: TileTheme.dark(),
  cardTheme: CardThemeData.dark(),
  switchTheme: AppSwitchTheme.dark(),
  dividerTheme: DividerTheming.dark(),
);