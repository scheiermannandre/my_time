import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/layers/interface/presentation/tab_page/tab_page_controller.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

/// This is the custom TabPage widget.
/// It is used to display a page that has a persistet TabBar as PageView at the top and a PageView below.
/// It is prepared so, that if the ContentPageView is scrolled, the TabBarPageView is scrolled as well.
/// The TabBarPageView is not scrollable.
/// The TabItems inside the TabBarPageView are clickable and will scroll the ContentPageView to the corresponding page.
class TabPage extends ConsumerStatefulWidget {
  const TabPage({
    super.key,
    required this.itemCount,
    required this.tabItemBuilder,
    required this.pageItemBuilder,
    required this.stateKey,
  });
  final String stateKey;
  final int itemCount;
  final IndexedWidgetBuilder tabItemBuilder;
  final IndexedWidgetBuilder pageItemBuilder;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<TabPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller =
        ref.read(tabPageControllerProvider(widget.stateKey).notifier);
    final state = ref.watch(tabPageControllerProvider(widget.stateKey));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          children: [
            SizedBox(
              height: 56,
              width: double.infinity,
              child: SnappyListView(
                reverse: false,
                controller: state.tabItemPagecontroller,
                itemCount: widget.itemCount,
                itemSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                visualisation: ListVisualisation.enlargement(
                    horizontalMultiplier: 1.3, verticalMultiplier: 1.3),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () => controller.animatePageViews(index),
                      child: widget.tabItemBuilder(context, index));
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            if (notification.direction != ScrollDirection.idle) {
              (state.tabItemPagecontroller.position
                      as ScrollPositionWithSingleContext)
                  .goIdle();
              state.isContentPageViewScrolling = true;
              // only needed if you want to scroll the TabBarPageView as well
              //state.isTabItemPageViewcrolling = false;
            } else {
              state.isContentPageViewScrolling = false;
            }
          }
          return false;
        },
        child: PageView.builder(
          controller: state.contentPageController,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return widget.pageItemBuilder(context, index);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
