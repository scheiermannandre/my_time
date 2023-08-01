import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

/// Navigation bar that is used to enable bottom navigation.
class NavBar extends StatefulWidget {
  /// Creates a [NavBar].
  const NavBar({
    required this.items,
    super.key,
    this.onTap,
    this.startIndex = 0,
    this.backgroundColor = Colors.white,
    this.selectedBackgroundColor = Colors.blue,
    this.unSelectedBackgroundColor = Colors.transparent,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.iconColor = Colors.black,
    this.style = const TextStyle(),
    this.padding = const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
  });

  /// Callback that is called when a tile is tapped.
  final ValueChanged<int>? onTap;

  /// Items of the navigation bar.
  final List<CustomNavBarItem> items;

  /// Index of the selected item on start.
  final int startIndex;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Background color of the selected item.
  final Color selectedBackgroundColor;

  /// Background color of the unselected items.
  final Color unSelectedBackgroundColor;

  /// Color of the icons.
  final Color iconColor;

  /// Style of the label.
  final TextStyle style;

  /// Padding of the tiles.
  final EdgeInsets padding;

  /// Main axis alignment of the tiles.
  final MainAxisAlignment mainAxisAlignment;

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
    for (var i = 0; i < widget.items.length; i++) {
      itemsExtendedState.add(false);
    }
    final allFalse = !itemsExtendedState.any((element) => element == true);
    if (allFalse) {
      itemsExtendedState[widget.startIndex] = true;
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    const maxItemWidth = Breakpoint.mobile;
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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: alignment,
          children: List<Widget>.generate(
            widget.items.length,
            (index) => _itemBuilder(context, index),
          ).toList(),
        ),
      ),
    );
  }
}
