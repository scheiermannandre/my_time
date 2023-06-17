import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/week/week_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/week/week_tab_item.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

class WeeksTabPage extends StatefulWidget {
  const WeeksTabPage({super.key});

  @override
  State<WeeksTabPage> createState() => _WeeksTabPageState();
}

class _WeeksTabPageState extends State<WeeksTabPage>
    with TickerProviderStateMixin {
  final List<({String week, String dateSpan})> weeks = [
    (week: 'CW 24', dateSpan: '12.06 - 18.06'),
    (week: 'CW 25', dateSpan: '19.06 - 25.06'),
    (week: 'CW 26', dateSpan: '26.06 - 02.07'),
    (week: 'CW 27', dateSpan: '03.07 - 09.07'),
    (week: 'CW 28', dateSpan: '10.07 - 16.07'),
    (week: 'CW 29', dateSpan: '17.07 - 23.07'),
    (week: 'CW 30', dateSpan: '24.07 - 30.07'),
    (week: 'CW 31', dateSpan: '31.07 - 06.08'),
    (week: 'CW 32', dateSpan: '07.08 - 13.08'),
    (week: 'CW 33', dateSpan: '14.08 - 20.08'),
    (week: 'CW 34', dateSpan: '21.08 - 27.08'),
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
                  return WeekTabItem(
                    week: weeks[index].week,
                    dateSpan: weeks[index].dateSpan,
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
            return const WeekPage();
          },
        ),
      ),
    );
  }
}
