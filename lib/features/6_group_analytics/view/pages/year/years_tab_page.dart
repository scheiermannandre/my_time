import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/tab_bar/tab_item.dart';
import 'package:my_time/features/6_group_analytics/view/pages/year/year_page.dart';
import 'package:my_time/features/interface/presentation/tab_page/tab_page.dart';

/// Shows analytics per day
/// Has a TabBar with the days the years has logged time for
/// Rght now it is hardcoded and just a shell, later a controller
/// and riverpod will be used to get the data from the backend and manage state
class YearTabPage extends StatefulWidget {
  const YearTabPage({super.key});
  @override
  State<YearTabPage> createState() => _YearTabPageState();
}

class _YearTabPageState extends State<YearTabPage>
    with TickerProviderStateMixin {
  final List<String> years = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  @override
  Widget build(BuildContext context) {
    return TabPage(
      stateKey: 'years',
      itemCount: years.length,
      tabItemBuilder: (context, index) {
        return TabItem(children: [
          Text(years[index], style: const TextStyle(fontSize: 16)),
        ]);
      },
      pageItemBuilder: (context, index) {
        return const YearPage();
      },
    );
  }
}
