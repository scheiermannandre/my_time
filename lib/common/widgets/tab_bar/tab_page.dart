import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:snappy_list_view/snappy_list_view.dart';
///
/// This is the custom TabPage widget.
/// It is used to display a page that has a persistet TabBar as PageView at the top and a PageView below.
/// It is prepared so, that if the ContentPageView is scrolled, the TabBarPageView is scrolled as well.
/// The TabBarPageView is not scrollable.
/// The TabItems inside the TabBarPageView are clickable and will scroll the ContentPageView to the corresponding page.
class TabPage extends StatefulWidget {
  const TabPage(
      {super.key,
      required this.itemCount,
      required this.tabItemBuilder,
      required this.pageItemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder tabItemBuilder;
  final IndexedWidgetBuilder pageItemBuilder;

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  final PageController _tabItemPagecontroller = PageController(initialPage: 0);
  final PageController _contentPageController = PageController(initialPage: 0);
  // only needed if you want to scroll the TabBarPageView as well
  //late bool _isTabItemPageViewcrolling;
  late bool _isContentPageViewScrolling;

  @override
  void initState() {
    super.initState();
    // only needed if you want to scroll the TabBarPageView as well
    //_isTabItemPageViewcrolling = false;
    _isContentPageViewScrolling = false;
    // only needed if you want to scroll the TabBarPageView as well
    // _tabItemPagecontroller.addListener(() {
    //   if (_isTabItemPageViewcrolling) {}
    // });

    // The listener for the ContentPageView handles the scrolling of the TabBarPageView and synchronizes 
    // the scrolling of the TabBarPageView with the ContentPageView
    _contentPageController.addListener(() {
      if (_isContentPageViewScrolling) {
        _tabItemPagecontroller.position.correctPixels(_contentPageController.offset *
            _contentPageController.viewportFraction /
            _contentPageController.viewportFraction);
        _tabItemPagecontroller.position.notifyListeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _tabItemPagecontroller,
                itemCount: widget.itemCount,
                itemSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                visualisation: ListVisualisation.enlargement(
                    horizontalMultiplier: 1.3, verticalMultiplier: 1.3),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        _tabItemPagecontroller.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                        _contentPageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
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
              (_tabItemPagecontroller.position as ScrollPositionWithSingleContext)
                  .goIdle();
              _isContentPageViewScrolling = true;
              // only needed if you want to scroll the TabBarPageView as well
              //_isTabItemPageViewcrolling = false;
            } else {
              _isContentPageViewScrolling = false;
            }
          }
          return false;
        },
        child: PageView.builder(
          controller: _contentPageController,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return widget.pageItemBuilder(context, index);
          },
        ),
      ),
    );
  }
}