import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/size_tokens.dart';

/// An item within an [ExpandableTile].
class ExpandableTileItem {
  /// Constructs an [ExpandableTileItem] with the required title.
  ExpandableTileItem({
    required this.title,
    this.trailingIcon,
    this.onPressed,
  });

  /// The title of the expandable tile item.
  final String title;

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
    required this.title,
    required this.items,
    this.collapseOnContentTap = true,
    super.key,
  });

  /// The title widget of the expandable tile.
  final String title;

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

    return Card(
      child: AnimatedBuilder(
        animation: dropdownAnimation,
        builder: (context, child) {
          return _ExpandableTileTitleWidget(
            heightFactor: dropdownAnimation.value,
            height: height,
            toggleDropdown: toggleDropdown,
            title: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
            ),
            rotationAnimation: rotationAnimation,
            child: child,
          );
        },
        child: _ExpandableTileContentWidget(
          items: widget.items,
          collapseOnContentTap: widget.collapseOnContentTap,
          toggleDropdown: toggleDropdown,
        ),
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
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: toggleDropdown,
          title: Row(
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
                    color: ThemeColorBuilder(context).getGuidingIconColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: heightFactor,
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Widget for rendering the content of an expandable tile.
class _ExpandableTileContentWidget extends StatelessWidget {
  const _ExpandableTileContentWidget({
    required this.items,
    required this.collapseOnContentTap,
    required this.toggleDropdown,
  });

  /// The list of items within the expandable tile.
  final List<ExpandableTileItem> items;

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
          return _ExpandableTileContent(
            onPressed: items[index].onPressed != null
                ? () {
                    if (collapseOnContentTap) {
                      toggleDropdown();
                    }
                    items[index].onPressed!();
                  }
                : null,
            title: Text(
              items[index].title,
              overflow: TextOverflow.ellipsis,
            ),
            icon: items[index].trailingIcon,
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
    this.onPressed,
    this.icon,
  });

  /// The title widget.
  final Widget title;

  /// Icon widget.
  final Widget? icon;

  /// Callback function called when the tile content is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
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
      onTap: onPressed,
    );
  }
}
