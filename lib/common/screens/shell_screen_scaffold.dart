import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/global/globals.dart';

class ShellScreenScaffold extends HookWidget {
  const ShellScreenScaffold({super.key, required this.children, this.appbar});
  final List<ShellPage> children;
  final PreferredSizeWidget? appbar;
  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    return Scaffold(
      appBar: appbar,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: NavBar(
          onTap: (index) {
            _changeTab(pageController, index);
          },
          startIndex: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          unSelectedBackgroundColor: Theme.of(context).colorScheme.background,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          iconColor: GlobalProperties.textAndIconColor,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
          items: children
              .map(
                (page) => CustomNavBarItem(
                    iconData: page.iconData, label: page.label),
              )
              .toList(),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {},
        children: children,
      ),
    );
  }

  void _changeTab(PageController pageController, int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }
}
