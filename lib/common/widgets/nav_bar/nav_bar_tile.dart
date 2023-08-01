import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/show_up_widget.dart';

/// Tile that implements the NavBarItem and makes user interaction possible.
class NavBarTile extends StatefulWidget {
  /// Creates a [NavBarTile].
  const NavBarTile({
    required this.item,
    required this.onTap,
    required this.index,
    required this.isExtended,
    required this.selectedBackgroundColor,
    required this.unSelectedBackgroundColor,
    required this.style,
    super.key,
  });

  /// Item of the tile.
  final CustomNavBarItem item;

  /// Style of the label.
  final TextStyle style;

  /// Callback that is called when the tile is tapped.
  final ValueChanged<int>? onTap;

  /// Index of the tile.
  final int index;

  /// Whether the tile is extended or not.
  final bool isExtended;

  /// Background color of the tile when it is selected.
  final Color selectedBackgroundColor;

  /// Background color of the tile when it is not selected.
  final Color unSelectedBackgroundColor;

  @override
  State<NavBarTile> createState() => _NavBarTileState();
}

class _NavBarTileState extends State<NavBarTile> {
  Size _textSize(Text text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text.data, style: text.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.item.label,
      style: widget.style,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    return InkWell(
      onTap: () {
        if (!widget.isExtended) {
          widget.onTap!(widget.index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: widget.isExtended
              ? widget.selectedBackgroundColor
              : widget.unSelectedBackgroundColor,
          border: Border.all(
            color: widget.isExtended
                ? widget.selectedBackgroundColor
                : widget.unSelectedBackgroundColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.iconData,
              size: 26,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            AnimatedContainer(
              width: !widget.isExtended ? 0 : _textSize(text).width, //50,
              duration: const Duration(milliseconds: 300),
              child: !widget.isExtended
                  ? const SizedBox.shrink()
                  : ShowUpWidget(
                      delay: 300,
                      child: text,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
