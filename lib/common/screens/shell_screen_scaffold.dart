import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/global/globals.dart';

/// A Scaffold that contains a [PageView] and a [NavBar], so that pages can be
/// inserted and be switched by the user can using the NavrBar.
class ShellScreenScaffold extends HookWidget {
  /// Creates a [ShellScreenScaffold].
  const ShellScreenScaffold({
    required List<ShellPage> children,
    super.key,
    PreferredSizeWidget? appbar,
  })  : _appbar = appbar,
        _children = children;

  final List<ShellPage> _children;
  final PreferredSizeWidget? _appbar;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    return Scaffold(
      appBar: _appbar,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: NavBar(
          onTap: (index) {
            _changeTab(pageController, index);
          },
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          unSelectedBackgroundColor: Theme.of(context).colorScheme.background,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
          items: _children
              .map(
                (page) => CustomNavBarItem(
                  iconData: page.getIconData(),
                  label: page.getLabel(context),
                ),
              )
              .toList(),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {},
        children: _children,
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
