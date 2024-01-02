import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

class TabBarScaffold extends StatefulWidget {
  const TabBarScaffold({
    required this.fetchMore,
    required this.isLoading,
    required this.length,
    required this.pageBuilder,
    required this.tabItemBuilder,
    super.key,
  });

  final Future<void> Function(AxisDirection direction)? fetchMore;
  final bool isLoading;
  final int length;
  final Widget Function(BuildContext context, int index) pageBuilder;
  final Widget Function(BuildContext context, int index) tabItemBuilder;

  @override
  State<TabBarScaffold> createState() => _TabBarScaffoldState();
}

class _TabBarScaffoldState extends State<TabBarScaffold> {
  late final PageController tabBarController;
  late final PageController pageViewController;
  bool isContentPageViewScrolling = false;

  int initialIndex = 0;
  static int initialPageValue = 9999;

  @override
  void initState() {
    super.initState();
    final length = widget.length - 1;
    initialIndex = (length / 2).round();

    tabBarController = PageController(initialPage: initialPageValue);
    pageViewController = PageController(initialPage: initialPageValue);

    pageViewController.addListener(() {
      if (isContentPageViewScrolling) {
        tabBarController.position.correctPixels(
          pageViewController.offset *
              pageViewController.viewportFraction /
              pageViewController.viewportFraction,
        );
        tabBarController.position.notifyListeners();
      }
    });
  }

  /// Handles the tap on a TabItem.
  void animatePageViews(int index) {
    tabBarController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  int getIndex(int unrealIndex) {
    final relativeIndex = unrealIndex - initialPageValue;
    return initialIndex + relativeIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 56,
            width: double.infinity,
            child: Center(
              child: SnappyListView(
                controller: tabBarController,
                itemCount: initialPageValue * 2,
                itemSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                visualisation: ListVisualisation.enlargement(
                  horizontalMultiplier: 1.4,
                  verticalMultiplier: 1.4,
                ),
                itemBuilder: (context, unrealIndex) {
                  final index = getIndex(unrealIndex);
                  Widget child = const SizedBox.shrink();
                  if (index >= 0 && index < widget.length) {
                    child = widget.tabItemBuilder(context, index);
                  }
                  return InkWell(
                    onTap: () => animatePageViews(unrealIndex),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: SpaceTokens.small,
                        horizontal: SpaceTokens.medium,
                      ),
                      child: child,
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          Expanded(
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is UserScrollNotification) {
                  if (notification.direction != ScrollDirection.idle) {
                    (tabBarController.position
                            as ScrollPositionWithSingleContext)
                        .goIdle();
                    isContentPageViewScrolling = true;
                  } else {
                    isContentPageViewScrolling = false;
                  }
                }
                return false;
              },
              child: PageView.builder(
                controller: pageViewController,
                itemCount: initialPageValue * 2,
                onPageChanged: (unrealIndex) async {
                  final relativeIndex = unrealIndex - initialPageValue;

                  final index = getIndex(unrealIndex);
                  if (!widget.isLoading) {
                    final direction = relativeIndex > 0
                        ? AxisDirection.left
                        : AxisDirection.right;

                    final leftDistance = index + 1;
                    final rightDistance = widget.length - leftDistance;

                    if (direction == AxisDirection.left && rightDistance <= 3) {
                      await widget.fetchMore!(AxisDirection.right);
                    } else if (direction == AxisDirection.right &&
                        leftDistance <= 3) {
                      await widget.fetchMore!(AxisDirection.left);
                      // await for success and increase the initialIndex
                      // because the list grew in size and items have been
                      // inserted to the left so the initialIndex needs
                      // to be increased it should be increased by the
                      // number of items inserted
                      initialIndex += 1;
                    }
                  }
                },
                itemBuilder: (context, unrealIndex) =>
                    widget.pageBuilder(context, getIndex(unrealIndex)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
