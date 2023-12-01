import 'package:flutter/material.dart';
import 'package:my_time/config/theme/input_decoration_theme.dart';
import 'package:my_time/config/theme/primary_button_theme.dart';
import 'package:my_time/config/theme/secondary_button_theme.dart';
import 'package:my_time/config/theme/text_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

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
    surfaceTint: Colors.transparent, // removes color blur on dialog background
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
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(Size.zero),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(
          horizontal: SpaceTokens.medium,
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            CornerRadiusTokens.small,
          ),
        ),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        DarkThemeColorTokens.primaryColor,
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        DarkThemeColorTokens.primaryColor.withOpacity(0.1),
      ),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: DarkThemeColorTokens.mediumColor,
  ),

  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: DarkThemeColorTokens.primaryColor,
  ),

  // This is needed
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
);
