import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/tab_bar/tab_item.dart';
import 'package:my_time/layers/interface/presentation/tab_page/tab_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/pages/day/day_page.dart';

/// Shows analytics per day
/// Has a TabBar with the days the user has logged time for
/// Rght now it is hardcoded and just a shell, later a controller 
/// and riverpod will be used to get the data from the backend and manage state
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

  @override
  Widget build(BuildContext context) {
    return TabPage(
      stateKey: 'days',
      itemCount: days.length,
      tabItemBuilder: (context, index) {
        return TabItem(children: [
          Text(days[index].weekDay, style: const TextStyle(fontSize: 10)),
          Text(days[index].date, style: const TextStyle(fontSize: 16)),
        ]);
      },
      pageItemBuilder: (context, index) {
        return const DayPage();
      },
    );
  }
}

