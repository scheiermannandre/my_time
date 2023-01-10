import 'dart:async';

import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final List<CustomNavBarItem> items;
  final int startIndex;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color unSelectedBackgroundColor;
  final Color iconColor;
  final TextStyle style;

  final MainAxisAlignment mainAxisAlignment;

  const CustomNavBar({
    super.key,
    this.onTap,
    required this.items,
    this.startIndex = 0,
    this.backgroundColor = Colors.white,
    this.selectedBackgroundColor = Colors.blue,
    this.unSelectedBackgroundColor = Colors.transparent,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.iconColor = Colors.black,
    this.style = const TextStyle(),
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int currentIndex;
  List<bool> itemsExtendedState = [];
  List<_CustomNavBarTile> tiles = [];
  @override
  void initState() {
    currentIndex = 0;
    _initItems();
    super.initState();
  }

  void _test(int index) {
    widget.onTap!(index);
    setState(() {
      itemsExtendedState[currentIndex] = false;
      currentIndex = index;
      itemsExtendedState[currentIndex] = true;
    });
  }

  void _initItems() {
    for (int i = 0; i < widget.items.length; i++) {
      itemsExtendedState.add(false);
    }
    bool allFalse = !itemsExtendedState.any((element) => element == true);
    if (allFalse) {
      itemsExtendedState[widget.startIndex] = true;
    }
  }

  List<Widget> _buildItems() {
    tiles.clear();
    for (int i = 0; i < widget.items.length; i++) {
      _CustomNavBarTile tile = _CustomNavBarTile(
        selectedBackgroundColor: widget.selectedBackgroundColor,
        unSelectedBackgroundColor: widget.unSelectedBackgroundColor,
        item: widget.items[i],
        onTap: _test,
        index: i,
        isExtended: itemsExtendedState[i],
        style: widget.style,
      );
      tiles.add(tile);
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: _buildItems(),
      ),
    );
  }
}

class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;

  ShowUp({required this.child, this.delay = 0});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(-0.1, 0.0), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}

class CustomNavBarItem {
  final IconData iconData;
  final String label;
  CustomNavBarItem({required this.iconData, required this.label});
}

class _CustomNavBarTile extends StatefulWidget {
  final CustomNavBarItem item;
  final TextStyle style;
  final ValueChanged<int>? onTap;
  final int index;
  final bool isExtended;
  final Color selectedBackgroundColor;
  final Color unSelectedBackgroundColor;

  const _CustomNavBarTile({
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
  State<_CustomNavBarTile> createState() => __CustomNavBarTileState();
}

class __CustomNavBarTileState extends State<_CustomNavBarTile> {
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
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                  : ShowUp(
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
