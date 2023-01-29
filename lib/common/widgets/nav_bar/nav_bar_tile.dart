import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/show_up_widget.dart';

class NavBarTile extends StatefulWidget {
  final CustomNavBarItem item;
  final TextStyle style;
  final ValueChanged<int>? onTap;
  final int index;
  final bool isExtended;
  final Color selectedBackgroundColor;
  final Color unSelectedBackgroundColor;

  const NavBarTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.index,
    required this.isExtended,
    required this.selectedBackgroundColor,
    required this.unSelectedBackgroundColor,
    required this.style,
  });

  @override
  State<NavBarTile> createState() => _NavBarTileState();
}

class _NavBarTileState extends State<NavBarTile> {
  Size _textSize(Text text) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text.data, style: text.style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    Text text = Text(
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
