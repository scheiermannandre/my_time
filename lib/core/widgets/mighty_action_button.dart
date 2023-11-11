import 'package:flutter/material.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/size_tokens.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/config/theme/text_style_tokens.dart';

/// [MightyActionButton] is a class that provides the styled action buttons
/// for the app.
class MightyActionButton {
  /// Returns a styled primary action button.
  static ActionButton primary({
    required MightyThemeController themeController,
    required String label,
    required VoidCallback onPressed,
    Key? key,
  }) {
    final backgroundColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.primaryColor
        : DarkThemeColorTokens.primaryColor;

    final textColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.black
        : DarkThemeColorTokens.black;

    final borderColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.black
        : null;

    final splashColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.darkColor;

    return ActionButton.regular(
      title: Text(label, style: TextStyleTokens.body(textColor)),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(CornerRadiusTokens.small),
      borderColor: borderColor,
      splashColor: splashColor,
    );
  }

  /// Returns a styled secondary action button.
  static ActionButton secondary({
    required MightyThemeController themeController,
    required String label,
    required VoidCallback onPressed,
    Key? key,
  }) {
    final backgroundColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.white
        : DarkThemeColorTokens.darkestColor;

    final textColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.black
        : DarkThemeColorTokens.lightestColor;

    final borderColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.black
        : DarkThemeColorTokens.primaryColor;

    final splashColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.mediumColor
        : DarkThemeColorTokens.lightestColor;

    return ActionButton.regular(
      title: Text(label, style: TextStyleTokens.body(textColor)),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: BorderRadius.circular(CornerRadiusTokens.small),
      splashColor: splashColor,
    );
  }

  /// Returns a styled rounded action button with an icon.
  static ActionButton roundedIcon({
    required MightyThemeController themeController,
    required IconData iconData,
    required VoidCallback? onPressed,
    required bool isLoading,
    Key? key,
  }) {
    final backgroundColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.primaryColor
        : DarkThemeColorTokens.primaryColor;

    final splashColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.darkColor;

    final iconColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.darkestColor;

    return ActionButton.roundedIcon(
      iconData: iconData,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      isLoading: isLoading,
      iconColor: iconColor,
    );
  }

  /// Returns a styled rounded action button with an icon and a label.
  static LabeledIconButton roundedLabeledIcon({
    required MightyThemeController themeController,
    required IconData iconData,
    required String label,
    required VoidCallback? onPressed,
    required bool isLoading,
    Key? key,
  }) {
    final backgroundColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.primaryColor
        : DarkThemeColorTokens.primaryColor;

    final splashColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.darkColor;

    final iconColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkColor
        : DarkThemeColorTokens.darkestColor;

    final fontColor = themeController.secondaryTextColor;

    return ActionButton.roundedLabeledIcon(
      label: label,
      fontColor: fontColor,
      iconData: iconData,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      isLoading: isLoading,
      iconColor: iconColor,
    );
  }
}

/// [ActionButton] is a class that provides the action buttons without any
/// styling.
class ActionButton extends StatefulWidget {
  /// Creates an action button.
  const ActionButton({
    required this.title,
    required this.onPressed,
    super.key,
    this.splashColor,
    this.decoration,
    this.width = double.infinity,
    this.height = SizeTokens.x48,
    this.isLoading = false,
    this.indicatorColor = Colors.black,
    this.splashBorderRadius = BorderRadius.zero,
  });

  /// Creates a regular action button.
  factory ActionButton.regular({
    required Widget title,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    Color? splashColor,
    BorderRadius? borderRadius,
    Color? borderColor,
    Key? key,
    bool isLoading = false,
  }) {
    final radius = borderRadius ?? BorderRadius.zero;

    return ActionButton(
      key: key,
      title: title,
      onPressed: onPressed,
      splashColor: splashColor,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? backgroundColor,
        ),
      ),
      splashBorderRadius: radius,
      isLoading: isLoading,
    );
  }

  /// Creates a rounded action button with an icon.
  factory ActionButton.roundedIcon({
    required IconData iconData,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required bool isLoading,
    required Color iconColor,
    Color? splashColor,
    Key? key,
  }) {
    backgroundColor = _getColor(
      onPressed: onPressed,
      isLoading: isLoading,
      color: backgroundColor,
    );

    iconColor = _getColor(
      onPressed: onPressed,
      isLoading: isLoading,
      color: iconColor,
    );

    final radius = BorderRadius.circular(CornerRadiusTokens.veryLarge);

    return ActionButton(
      key: key,
      title: Icon(iconData, color: iconColor),
      onPressed: onPressed,
      isLoading: isLoading,
      splashBorderRadius: radius,
      splashColor: splashColor,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
      ),
      width: SizeTokens.x48,
      indicatorColor: iconColor,
    );
  }
  static Color _getColor({
    required VoidCallback? onPressed,
    required bool isLoading,
    required Color color,
  }) =>
      onPressed != null && !isLoading ? color : color.withOpacity(.5);

  /// Creates a rounded action button with an icon and a label.
  static LabeledIconButton roundedLabeledIcon({
    required IconData iconData,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required bool isLoading,
    required Color iconColor,
    required String label,
    required Color fontColor,
    required Color splashColor,
    Key? key,
  }) {
    backgroundColor = _getColor(
      onPressed: onPressed,
      isLoading: isLoading,
      color: backgroundColor,
    );

    iconColor = _getColor(
      onPressed: onPressed,
      isLoading: isLoading,
      color: iconColor,
    );
    return LabeledIconButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      icon: iconData,
      iconColor: iconColor,
      label: label,
      fontColor: fontColor,
      isLoading: isLoading,
      splashColor: splashColor,
    );
  }

  /// The title widget to display on the button.
  final Widget title;

  /// The callback function to be called when the button is pressed.
  final VoidCallback? onPressed;

  /// The color of the splash effect when the button is pressed.
  final Color? splashColor;

  /// The color of the loading indicator.
  final Color? indicatorColor;

  /// The decoration to apply to the button.
  final BoxDecoration? decoration;

  /// The border radius of the splash effect.
  final BorderRadius splashBorderRadius;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// Whether the button is currently in a loading state.
  final bool isLoading;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: widget.decoration,
        width: widget.width,
        height: widget.height,
        child: InkWell(
          splashColor: widget.splashColor != null
              ? widget.splashColor!.withOpacity(.1)
              : null,
          borderRadius: widget.splashBorderRadius,
          onTap: widget.onPressed == null || widget.isLoading
              ? null
              : () {
                  setState(() {
                    clicked = true;
                    if (!widget.isLoading) {
                      widget.onPressed!();
                    }
                  });
                },
          child: clicked && widget.isLoading
              ? Center(
                  child: SizedBox(
                    height: SizeTokens.x24,
                    width: SizeTokens.x24,
                    child: CircularProgressIndicator(
                      color: widget.indicatorColor,
                    ),
                  ),
                )
              : Center(child: widget.title),
        ),
      ),
    );
  }
}

/// [LabeledIconButton] is a class that provides the action buttons with an
/// icon and a label.
class LabeledIconButton extends StatelessWidget {
  /// Creates a labeled icon button.
  const LabeledIconButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.fontColor,
    required this.isLoading,
    required this.splashColor,
    super.key,
  });

  /// Callback function to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The background color of the button.
  final Color backgroundColor;

  /// The icon to be displayed on the button.
  final IconData icon;

  /// The color of the icon on the button.
  final Color iconColor;

  /// The label or text to be displayed alongside the icon on the button.
  final String label;

  /// The color of the text label on the button.
  final Color fontColor;

  /// A flag indicating whether the button is in a loading state.
  final bool isLoading;

  /// The color of the splash effect when the button is tapped.
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeTokens.x72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton.roundedIcon(
            iconData: icon,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            isLoading: isLoading,
            iconColor: iconColor,
            splashColor: splashColor,
            key: key,
          ),
          const SizedBox(height: SpaceTokens.verySmall),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyleTokens.small(fontColor),
          ),
        ],
      ),
    );
  }
}
