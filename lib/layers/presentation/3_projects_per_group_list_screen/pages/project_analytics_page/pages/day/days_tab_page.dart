import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/day/day_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/day/day_tab_item.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

class DaysTabPage extends StatefulWidget {
  const DaysTabPage({super.key});

  @override
  State<DaysTabPage> createState() => _DaysTabPageState();
}

class _DaysTabPageState extends State<DaysTabPage>
    with TickerProviderStateMixin {
  final List<({String weekDay, String date})> days = [
    (weekDay: 'Fr.', date: '16.06'),
    (weekDay: 'Sa.', date: '17.06'),
    (weekDay: 'So.', date: '18.06'),
    (weekDay: 'Mo.', date: '19.06'),
    (weekDay: 'Di.', date: '20.06'),
    (weekDay: 'Mi.', date: '21.06'),
    (weekDay: 'Do.', date: '22.06'),
    (weekDay: 'Fr.', date: '23.06'),
    (weekDay: 'Sa.', date: '24.06'),
    (weekDay: 'So.', date: '25.06'),
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
                  return DayTabItem(
                    weekDay: days[index].weekDay,
                    date: days[index].date,
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
            return const DayPage();
          },
        ),
      ),
    );
  }
}
