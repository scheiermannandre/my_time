import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/text_style_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'mighty_theme.g.dart';

@riverpod

/// A controller for managing the theme mode in the Mighty App.
///
/// This controller extends the automatically generated controller
/// [_$MightyThemeController] and provides additional functionalities for
/// accessing theme-related properties and methods.
class MightyThemeController extends _$MightyThemeController {
  /// Gets the current system theme mode.
  SystemThemeMode get themeMode => state;

  @override
  SystemThemeMode build() {
    // 1. Create an observer to update the state
    final observer = _PlatformBrightnessObserver((themeMode) {
      state = themeMode;
    });

    // 2. Initialize from the initial locale
    state = observer.getSystemThemeMode();

    // 3. Register the observer and dispose it when no longer needed
    final binding = WidgetsBinding.instance..addObserver(observer);
    ref.onDispose(() => binding.removeObserver(observer));

    return state;
  }

  /// Gets the color for actions based on the current theme mode.
  Color get actionsColor => ThemeColors.getActionsColor(state);

  /// Gets the color for heading text based on the current theme mode.
  Color get headingTextColor => ThemeColors.getHeadingTextColor(state);

  /// Gets the color for secondary text based on the current theme mode.
  Color get secondaryTextColor => ThemeColors.getSecondaryTextColor(state);

  /// Gets the color for non-decorative borders based on the current theme mode.
  Color get nonDecorativeBorderColor =>
      ThemeColors.getNonDecorativeBorderColor(state);

  /// Gets the color for errors based on the current theme mode.
  Color get errorColor => ThemeColors.getErrorColor(state);

  /// Gets the color for decorative borders based on the current theme mode.
  Color get decorativeBorderColor =>
      ThemeColors.getDecorativeBorderColor(state);

  /// Gets the color for alternate background based on the current theme mode.
  Color get alternateBackgroundColor =>
      ThemeColors.getAlternateBackgroundColor(state);

  /// Gets the color for the main background based on the current theme mode.
  Color get mainBackgroundColor => ThemeColors.getMainBackgroundColor(state);

  /// Gets the [TextStyle] for headline3 based on the current theme mode.
  TextStyle get headline3 => TextStyleTokens.getHeadline3(headingTextColor);

  /// Gets the [TextStyle] for headline4 based on the current theme mode.
  TextStyle get headline4 => TextStyleTokens.getHeadline4(headingTextColor);

  /// Gets the [TextStyle] for headline5 based on the current theme mode.
  TextStyle get headline5 => TextStyleTokens.getHeadline5(headingTextColor);

  /// Gets the [TextStyle] for body text based on the current theme mode.
  TextStyle get body => TextStyleTokens.body(secondaryTextColor);

  /// Gets the [TextStyle] for small text based on the current theme mode.
  TextStyle get small => TextStyleTokens.small(headingTextColor);

  /// Gets the [TextStyle] for small headline text based on the current theme
  /// mode.
  TextStyle get smallHeadline =>
      TextStyleTokens.smallHeadline(headingTextColor);
}

/// Enum representing the system theme modes.
enum SystemThemeMode {
  /// Light theme mode.
  light,

  /// Dark theme mode.
  dark,
}

/// observer used to notify the caller when the brightness changes
class _PlatformBrightnessObserver extends WidgetsBindingObserver {
  _PlatformBrightnessObserver(this._didChangePlatformBrightness);
  final void Function(SystemThemeMode themeMode) _didChangePlatformBrightness;

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    final themeMode = getSystemThemeMode();
    _didChangePlatformBrightness(themeMode);
  }

  SystemThemeMode getSystemThemeMode() {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    final themeMode = brightness == Brightness.dark
        ? SystemThemeMode.dark
        : SystemThemeMode.light;
    return themeMode;
  }
}
