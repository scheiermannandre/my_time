import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/config/theme/tokens/size_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';

/// A tile that can be expanded to reveal additional items in a
/// dropdown-like manner.
class MightyExpandableTile extends StatelessWidget {
  /// Constructs a [MightyExpandableTile] with the required parameters.
  const MightyExpandableTile({
    required this.themeController,
    required this.title,
    required this.items,
    super.key,
  });

  /// The theme controller for adapting the tile's appearance.
  final MightyThemeController themeController;

  /// The title of the expandable tile.
  final String title;

  /// The list of items in the expandable tile.
  final List<MightyExpandableTileItem> items;

  @override
  Widget build(BuildContext context) {
    const cornerRadius = CornerRadiusTokens.small;

    return ExpandableTile(
      title: Text(
        title,
        style: themeController.headline5,
        overflow: TextOverflow.ellipsis,
      ),
      items: List<ExpandableTileItem>.generate(
        items.length,
        (index) => ExpandableTileItem(
          onPressed: items[index].onPressed,
          title: Text(
            items[index].title,
            style: themeController.alternateBody,
          ),
          trailingIcon: items[index].showTrailingIcon
              ? RotatedBox(
                  quarterTurns: 3,
                  child: Icon(
                    Icons.expand_more,
                    color: themeController.themeMode == SystemThemeMode.light
                        ? themeController.secondaryTextColor
                        : themeController.actionsColor,
                  ),
                )
              : null,
        ),
      ).toList(),
      collapseOnContentTap: true,
      backgroundColor: themeController.onBackgroundColor,
      iconColor: themeController.themeMode == SystemThemeMode.light
          ? LightThemeColorTokens.darkColor
          : DarkThemeColorTokens.primaryColor,
      splashColor: themeController.themeMode == SystemThemeMode.light
          ? LightThemeColorTokens.lightestColor
          : DarkThemeColorTokens.mediumColor,
      splashCornerRadius: cornerRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(
          color: themeController.themeMode == SystemThemeMode.light
              ? LightThemeColorTokens.lightColor
              : DarkThemeColorTokens.mediumColor,
        ),
      ),
    );
  }
}

/// An item within a [MightyExpandableTile].
class MightyExpandableTileItem {
  /// Constructs a [MightyExpandableTileItem] with the required title.
  MightyExpandableTileItem({
    required this.title,
    this.showTrailingIcon = true,
    this.onPressed,
  });

  /// The title of the expandable tile item.
  final String title;

  /// Indicates whether to show a trailing icon.
  final bool showTrailingIcon;

  /// Callback function called when the tile item is pressed.
  final VoidCallback? onPressed;
}

/// An item within an [ExpandableTile].
class ExpandableTileItem {
  /// Constructs an [ExpandableTileItem] with the required title.
  ExpandableTileItem({
    required this.title,
    this.trailingIcon,
    this.onPressed,
  });

  /// The title of the expandable tile item.
  final Widget title;

  /// The trailing icon widget.
  final Widget? trailingIcon;

  /// Callback function called when the tile item is pressed.
  final VoidCallback? onPressed;
}

/// A customizable expandable tile that can reveal additional content
/// when expanded.
class ExpandableTile extends StatefulWidget {
  /// Constructs an [ExpandableTile] with the required parameters.
  const ExpandableTile({
    required this.backgroundColor,
    required this.title,
    required this.items,
    required this.splashColor,
    required this.splashCornerRadius,
    required this.iconColor,
    required this.collapseOnContentTap,
    this.decoration,
    super.key,
  });

  /// Decoration of the tile.
  final BoxDecoration? decoration;

  /// The title widget of the expandable tile.
  final Widget title;

  /// Background color of the tile.
  final Color backgroundColor;

  /// Icon color of the tile.
  final Color iconColor;

  /// Splash color when the tile is pressed.
  final Color splashColor;

  /// Corner radius for the splash effect.
  final double splashCornerRadius;

  /// Whether the tile should collapse when the content is tapped.
  final bool collapseOnContentTap;

  /// List of items within the expandable tile.
  final List<ExpandableTileItem> items;

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

/// The state of the [ExpandableTile].
class _ExpandableTileState extends State<ExpandableTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> dropdownAnimation;
  late Animation<double> rotationAnimation;

  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    dropdownAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    rotationAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(dropdownAnimation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Toggles the visibility of the dropdown content.
  void toggleDropdown() {
    isDropdownOpen = !isDropdownOpen;
    if (isDropdownOpen) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    const height = 56.0;
    const padding = EdgeInsets.only(
      left: SpaceTokens.medium,
      right: SpaceTokens.medium,
    );

    return AnimatedBuilder(
      animation: dropdownAnimation,
      builder: (context, child) {
        return _ExpandableTileTitleWidget(
          padding: padding,
          splashCornerRadius: widget.splashCornerRadius,
          splashColor: widget.splashColor,
          iconColor: widget.iconColor,
          backgroundColor: widget.backgroundColor,
          heightFactor: dropdownAnimation.value,
          height: height,
          toggleDropdown: toggleDropdown,
          title: widget.title,
          decoration: widget.decoration,
          rotationAnimation: rotationAnimation,
          child: child,
        );
      },
      child: _ExpandableTileContentWidget(
        items: widget.items,
        collapseOnContentTap: widget.collapseOnContentTap,
        toggleDropdown: toggleDropdown,
        padding: padding,
        iconColor: widget.iconColor,
        backgroundColor: widget.backgroundColor,
        splashColor: widget.splashColor,
        splashCornerRadius: widget.splashCornerRadius,
      ),
    );
  }
}

/// Widget for rendering the title of an expandable tile.
class _ExpandableTileTitleWidget extends StatelessWidget {
  const _ExpandableTileTitleWidget({
    required this.height,
    required this.toggleDropdown,
    required this.title,
    required this.child,
    required this.heightFactor,
    required this.rotationAnimation,
    required this.splashColor,
    required this.splashCornerRadius,
    required this.backgroundColor,
    required this.iconColor,
    this.decoration,
    this.padding = EdgeInsets.zero,
  });

  /// Decoration of the widget.
  final BoxDecoration? decoration;

  /// The height of the widget.
  final double height;

  /// Callback function called when the tile title is pressed.
  final VoidCallback? toggleDropdown;

  /// The title widget.
  final Widget title;

  /// The child widget.
  final Widget? child;

  /// The height factor for animation.
  final double? heightFactor;

  /// The animation for rotation.
  final Animation<double> rotationAnimation;

  /// Padding for the widget.
  final EdgeInsets padding;

  /// Splash color when the tile is pressed.
  final Color splashColor;

  /// Corner radius for the splash effect.
  final double splashCornerRadius;

  /// Background color of the widget.
  final Color backgroundColor;

  /// Icon color of the widget.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Column(
        children: [
          SizedBox(
            height: height,
            child: ActionButton.regular(
              borderRadius: BorderRadius.all(
                Radius.circular(splashCornerRadius),
              ),
              onPressed: toggleDropdown,
              backgroundColor: backgroundColor,
              splashColor: splashColor,
              title: Padding(
                padding: padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: title),
                    Container(
                      alignment: Alignment.center,
                      width: SizeTokens.x24,
                      child: RotationTransition(
                        turns: rotationAnimation,
                        child: Icon(
                          Icons.expand_more,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: heightFactor,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for rendering the content of an expandable tile.
class _ExpandableTileContentWidget extends StatelessWidget {
  const _ExpandableTileContentWidget({
    required this.items,
    required this.splashColor,
    required this.splashCornerRadius,
    required this.iconColor,
    required this.backgroundColor,
    required this.collapseOnContentTap,
    required this.toggleDropdown,
    this.padding = EdgeInsets.zero,
  });

  /// The list of items within the expandable tile.
  final List<ExpandableTileItem> items;

  /// Padding for the widget.
  final EdgeInsets padding;

  /// Splash color when the tile is pressed.
  final Color splashColor;

  /// Corner radius for the splash effect.
  final double splashCornerRadius;

  /// Icon color of the widget.
  final Color iconColor;

  /// Background color of the widget.
  final Color backgroundColor;

  /// Whether the tile should collapse when the content is tapped.
  final bool collapseOnContentTap;

  /// Callback function called when the dropdown content is pressed.
  final VoidCallback toggleDropdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        items.length,
        (index) {
          final radius = index == items.length - 1
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(splashCornerRadius),
                  bottomRight: Radius.circular(splashCornerRadius),
                )
              : BorderRadius.zero;

          return _ExpandableTileContent(
            padding: padding,
            splashColor: splashColor,
            splashBorderRadius: radius,
            onPressed: items[index].onPressed != null
                ? () {
                    if (collapseOnContentTap) {
                      toggleDropdown();
                    }
                    items[index].onPressed!();
                  }
                : null,
            title: items[index].title,
            icon: items[index].trailingIcon,
            iconColor: iconColor,
            backgroundColor: backgroundColor,
          );
        },
      ).toList(),
    );
  }
}

/// Widget for rendering the content of an expandable tile item.
class _ExpandableTileContent extends StatelessWidget {
  const _ExpandableTileContent({
    required this.title,
    required this.splashColor,
    required this.splashBorderRadius,
    required this.iconColor,
    required this.backgroundColor,
    this.onPressed,
    this.icon,
    this.padding = EdgeInsets.zero,
  });

  /// The title widget.
  final Widget title;

  /// Splash color when the tile content is pressed.
  final Color splashColor;

  /// Corner radius for the splash effect.
  final BorderRadius splashBorderRadius;

  /// Icon widget.
  final Widget? icon;

  /// Icon color.
  final Color iconColor;

  /// Background color of the widget.
  final Color backgroundColor;

  /// Callback function called when the tile content is pressed.
  final VoidCallback? onPressed;

  /// Padding for the widget.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ActionButton.regular(
      title: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            if (icon != null)
              Container(
                alignment: Alignment.center,
                width: SizeTokens.x24,
                child: icon,
              )
            else
              const SizedBox(),
          ],
        ),
      ),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      borderRadius: splashBorderRadius,
    );
  }
}
