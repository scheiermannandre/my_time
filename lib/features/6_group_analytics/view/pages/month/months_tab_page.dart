import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/tab_bar/tab_item.dart';
import 'package:my_time/features/6_group_analytics/view/pages/month/month_page.dart';
import 'package:my_time/features/interface/presentation/tab_page/tab_page.dart';

/// Shows analytics per months
/// Has a TabBar with the months the user has logged time for
/// Rght now it is hardcoded and just a shell, later a controller
/// and riverpod will be used to get the data from the backend and manage state
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

  @override
  Widget build(BuildContext context) {
    return TabPage(
      stateKey: 'months',
      itemCount: months.length,
      tabItemBuilder: (context, index) {
        return TabItem(children: [
          Text(months[index].month, style: const TextStyle(fontSize: 16)),
          Text(months[index].year, style: const TextStyle(fontSize: 10)),
        ]);
      },
      pageItemBuilder: (context, index) {
        return const MonthPage();
      },
    );
  }
}
