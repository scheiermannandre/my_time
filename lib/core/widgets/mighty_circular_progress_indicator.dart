import 'package:flutter/material.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/size_tokens.dart';
import 'package:my_time/config/theme/space_tokens.dart';

/// A circular progress indicator that adapts its appearance based
/// on the provided theme.
class MightyCircularProgressIndicator extends StatelessWidget {
  /// Constructs a [MightyCircularProgressIndicator] with the required
  /// theme controller.
  const MightyCircularProgressIndicator({
    required this.themeController,
    super.key,
  });

  /// The theme controller for adapting the progress indicator's appearance.
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    // Determine color based on the theme mode
    final color = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.primaryColor;

    // Determine background color based on the theme mode
    final backgroundColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.primaryColor
        : DarkThemeColorTokens.darkColor;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(SpaceTokens.small),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: SizeTokens.x24,
          width: SizeTokens.x24,
          child: CircularProgressIndicator(
            color: color,
          ),
        ),
      ),
    );
  }
}
