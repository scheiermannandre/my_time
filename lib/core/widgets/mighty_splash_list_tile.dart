import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';

/// A list tile with a splash effect, customizable with various parameters.
class MightySplashListTile extends StatelessWidget {
  /// Constructs a [MightySplashListTile] with the required parameters.
  const MightySplashListTile({
    required this.themeController,
    required this.text,
    super.key,
    this.showIcon = true,
    this.onPressed,
    this.iconData,
    this.contentPadding = EdgeInsets.zero,
  });

  /// The theme controller for adapting the tile's appearance.
  final MightyThemeController themeController;

  /// The text to display in the tile.
  final String text;

  /// Determines whether to show the icon in the tile.
  final bool showIcon;

  /// The callback function to be invoked when the tile is pressed.
  final VoidCallback? onPressed;

  /// The icon data to be displayed in the tile.
  final IconData? iconData;

  /// Padding applied to the content of the tile.
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return SplashListTile(
      title: Padding(
        padding: contentPadding,
        child: Text(
          text,
          style: themeController.alternateBody,
        ),
      ),
      onPressed: onPressed,
      trailingIcon: showIcon
          ? RotatedBox(
              quarterTurns: iconData == null ? 3 : 0,
              child: Icon(
                iconData ?? Icons.expand_more,
                color: themeController.themeMode == SystemThemeMode.light
                    ? themeController.secondaryTextColor
                    : themeController.actionsColor,
              ),
            )
          : null,
      foreGroundColor: themeController.themeMode == SystemThemeMode.light
          ? LightThemeColorTokens.lightColor
          : DarkThemeColorTokens.lightestColor,
    );
  }
}

/// A generic list tile with a splash effect, customizable with various
/// parameters.
class SplashListTile extends StatelessWidget {
  /// Constructs a [SplashListTile] with the required title.
  const SplashListTile({
    required this.title,
    super.key,
    this.backgroundColor = Colors.transparent,
    this.foreGroundColor,
    this.trailingIcon,
    this.onPressed,
    this.contentPadding = EdgeInsets.zero,
  });

  /// The background color of the tile.
  final Color backgroundColor;

  /// The foreground color of the tile.
  final Color? foreGroundColor;

  /// The main content of the tile.
  final Widget title;

  /// An optional icon to be displayed at the end of the tile.
  final Widget? trailingIcon;

  /// The callback function to be invoked when the tile is pressed.
  final VoidCallback? onPressed;

  /// Padding applied to the content of the tile.
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return ActionButton.regular(
      title: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: title),
            trailingIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
    );
  }
}
