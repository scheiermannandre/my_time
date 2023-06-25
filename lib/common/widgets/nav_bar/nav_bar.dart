import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

class NavBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final List<CustomNavBarItem> items;
  final int startIndex;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color unSelectedBackgroundColor;
  final Color iconColor;
  final TextStyle style;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;

  const NavBar(
      {super.key,
      this.onTap,
      required this.items,
      this.startIndex = 0,
      this.backgroundColor = Colors.white,
      this.selectedBackgroundColor = Colors.blue,
      this.unSelectedBackgroundColor = Colors.transparent,
      this.mainAxisAlignment = MainAxisAlignment.spaceAround,
      this.iconColor = Colors.black,
      this.style = const TextStyle(),
      this.padding = const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0)});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int currentIndex;
  List<bool> itemsExtendedState = [];
  List<NavBarTile> tiles = [];
  @override
  void initState() {
    currentIndex = 0;
    _initItems();
    super.initState();
  }

  void _onTap(int index) {
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

  Widget _itemBuilder(BuildContext context, int index) {
    var maxItemWidth = Breakpoint.mobile;
    return SizedBox(
      width: maxItemWidth / widget.items.length,
      child: Padding(
        padding: widget.padding,
        child: NavBarTile(
          selectedBackgroundColor: widget.selectedBackgroundColor,
          unSelectedBackgroundColor: widget.unSelectedBackgroundColor,
          item: widget.items[index],
          onTap: _onTap,
          index: index,
          isExtended: itemsExtendedState[index],
          style: widget.style,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const alignment = MainAxisAlignment.spaceBetween;
    return Container(
      height: kBottomNavigationBarHeight,
      color: widget.backgroundColor,
      child: ResponsiveAlign(
        maxContentWidth: Breakpoint.desktop,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: alignment,
          children: List<Widget>.generate(
                  widget.items.length, (index) => _itemBuilder(context, index))
              .toList(),
        ),
      ),
    );
  }
}
