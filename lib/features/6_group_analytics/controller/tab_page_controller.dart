import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_page_controller.g.dart';

/// State of the TabPage.
@riverpod
class TabPageController extends _$TabPageController {
  @override
  TabPageState build(String arg1) {
    return TabPageState();
  }

  /// Handles the tap on a TabItem.
  void animatePageViews(int index) {
    state.tabItemPagecontroller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    state.contentPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}

/// State of the TabPage.
class TabPageState {
  /// Creates a [TabPageState].
  TabPageState() {
    // only needed if you want to scroll the TabBarPageView as well
    //isTabItemPageViewcrolling = false;
    isContentPageViewScrolling = false;
    // only needed if you want to scroll the TabBarPageView as well
    // _tabItemPagecontroller.addListener(() {
    //   if (_isTabItemPageViewcrolling) {}
    // });

    // The listener for the ContentPageView handles the scrolling of the
    //TabBarPageView and synchronizes
    // the scrolling of the TabBarPageView with the ContentPageView
    contentPageController.addListener(() {
      if (isContentPageViewScrolling) {
        tabItemPagecontroller.position.correctPixels(
          contentPageController.offset *
              contentPageController.viewportFraction /
              contentPageController.viewportFraction,
        );
        tabItemPagecontroller.position.notifyListeners();
      }
    });
  }

  /// The controller for the TabBarPageView.
  final PageController tabItemPagecontroller = PageController();

  /// The controller for the ContentPageView.
  final PageController contentPageController = PageController();
  // only needed if you want to scroll the TabBarPageView as well
  //late bool _isTabItemPageViewcrolling;
  /// Returns true if the ContentPageView is scrolling.
  late bool isContentPageViewScrolling;
}
