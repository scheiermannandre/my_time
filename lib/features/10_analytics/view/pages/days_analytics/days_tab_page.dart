import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/10_analytics/view/pages/days_analytics/single_day_tab_page.dart';
import 'package:my_time/features/10_analytics/view/widgets/tabbar_scaffold.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

class DaysTabPage extends StatefulWidget {
  const DaysTabPage({
    required this.groupId,
    super.key,
  });

  final String groupId;

  @override
  State<DaysTabPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysTabPage> {
  final now = DateTime.now();
  late final List<DateTime> tabs;

  @override
  void initState() {
    tabs = [
      now.subtract(const Duration(days: 3)),
      now.subtract(const Duration(days: 2)),
      now.subtract(const Duration(days: 1)),
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 3)),
    ];
    super.initState();
  }

  bool isLoading = false;

  Future<void> fetchMore(AxisDirection direction) async {
    setState(() {
      isLoading = true;
    });
    //await Future.delayed(const Duration(seconds: 2));

    setState(() {
      if (direction == AxisDirection.right) {
        tabs.add(tabs.last.add(const Duration(days: 1)));
      } else {
        tabs.insert(0, tabs.first.subtract(const Duration(days: 1)));
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabBarScaffold(
      fetchMore: fetchMore,
      isLoading: isLoading,
      tabItemBuilder: (context, index) {
        return Column(
          children: [
            Text(tabs[index].toDayOfWeekString()),
            Text(tabs[index].toFormattedDayString()),
          ],
        );
      },
      length: tabs.length,
      pageBuilder: (context, index) {
        return SingleDayTabPage(
          groupId: widget.groupId,
          date: tabs[index],
        );
      },
    );
  }
}
