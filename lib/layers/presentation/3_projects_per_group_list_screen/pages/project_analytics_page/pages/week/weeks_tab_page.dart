import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/tab_bar/tab_item.dart';
import 'package:my_time/layers/interface/presentation/tab_page/tab_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/week/week_page.dart';

/// Shows analytics per weeks
/// Has a TabBar with the weeks the user has logged time for
/// Rght now it is hardcoded and just a shell, later a controller
/// and riverpod will be used to get the data from the backend and manage state
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

  @override
  Widget build(BuildContext context) {
    return TabPage(
      stateKey: 'weeks',
      itemCount: weeks.length,
      tabItemBuilder: (context, index) {
        return TabItem(children: [
          Text(weeks[index].week, style: const TextStyle(fontSize: 16)),
          Text(weeks[index].dateSpan, style: const TextStyle(fontSize: 10)),
        ]);
      },
      pageItemBuilder: (context, index) {
        return const WeekPage();
      },
    );
  }
}
