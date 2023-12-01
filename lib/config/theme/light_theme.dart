import 'package:flutter/material.dart';
import 'package:my_time/config/theme/input_decoration_theme.dart';
import 'package:my_time/config/theme/primary_button_theme.dart';
import 'package:my_time/config/theme/secondary_button_theme.dart';
import 'package:my_time/config/theme/text_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';

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
      foregroundColor: MaterialStateProperty.all<Color>(
        LightThemeColorTokens.darkColor,
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
        LightThemeColorTokens.darkColor,
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        LightThemeColorTokens.darkColor.withOpacity(0.1),
      ),
    ),
  ),

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
