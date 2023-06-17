import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/month/month_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/month/month_tab_item.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

class MonthsTabPage extends StatefulWidget {
  const MonthsTabPage({super.key});

  @override
  State<MonthsTabPage> createState() => _MonthsTabPageState();
}

class _MonthsTabPageState extends State<MonthsTabPage>
    with TickerProviderStateMixin {
  final List<({String month, String year})> months = [
    (month: 'January', year: '2023'),
    (month: 'February', year: '2023'),
    (month: 'March', year: '2023'),
    (month: 'April', year: '2023'),
    (month: 'May', year: '2023'),
    (month: 'June', year: '2023'),
    (month: 'July', year: '2023'),
    (month: 'August', year: '2023'),
    (month: 'September', year: '2023'),
    (month: 'Oktober', year: '2023'),
  ];
  final PageController _controller1 = PageController(initialPage: 0);
  final PageController _controller2 = PageController(initialPage: 0);
  late bool _isPage1Scrolling;
  late bool _isPage2Scrolling;

  @override
  void initState() {
    super.initState();
    _controller1.addListener(() {
      if (_isPage1Scrolling) {}
    });
    _controller2.addListener(() {
      if (_isPage2Scrolling) {
        _controller1.position.correctPixels(_controller2.offset *
            _controller2.viewportFraction /
            _controller2.viewportFraction);
        _controller1.position.notifyListeners();
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
                controller: _controller1,
                itemCount: 10,
                itemSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                visualisation: ListVisualisation.enlargement(
                    horizontalMultiplier: 1.3, verticalMultiplier: 1.3),
                itemBuilder: (context, index) {
                  return MonthTabItem(
                    month: months[index].month,
                    year: months[index].year,
                    onTap: () {
                      _controller1.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      _controller2.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                  );
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
              (_controller1.position as ScrollPositionWithSingleContext)
                  .goIdle();
              _isPage2Scrolling = true;
              _isPage1Scrolling = false;
            } else {
              _isPage2Scrolling = false;
            }
          }
          return false;
        },
        child: PageView.builder(
          controller: _controller2,
          itemCount: 10,
          itemBuilder: (context, index) {
            return const MonthPage();
          },
        ),
      ),
    );
  }
}
