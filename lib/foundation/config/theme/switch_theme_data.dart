import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';

/// Defines the appearance of the application's list tiles.
class AppSwitchTheme extends SwitchThemeData {
  /// Constructs a [AppSwitchTheme] for customizing list tile appearance.
  const AppSwitchTheme({
    super.thumbColor,
    super.trackOutlineColor,
    super.trackOutlineWidth,
  });

  /// Constructs a light-themed [AppSwitchTheme].
  factory AppSwitchTheme.light() {
    return AppSwitchTheme._get(
      thumbColor: LightThemeColorTokens.darkColor,
      trackOutlineColor: LightThemeColorTokens.mediumColor,
    );
  }

  /// Constructs a dark-themed [AppSwitchTheme].
  factory AppSwitchTheme.dark() {
    return AppSwitchTheme._get(
      trackOutlineColor: DarkThemeColorTokens.mediumColor,
    );
  }

  factory AppSwitchTheme._get({
    required Color trackOutlineColor,
    Color? thumbColor,
  }) {
    return AppSwitchTheme(
      thumbColor: thumbColor != null
          ? MaterialStateProperty.all<Color>(
              thumbColor,
            )
          : null,
      trackOutlineColor: MaterialStateProperty.all<Color>(
        trackOutlineColor,
      ),
      trackOutlineWidth: MaterialStateProperty.all<double>(1),
    );
  }
}
