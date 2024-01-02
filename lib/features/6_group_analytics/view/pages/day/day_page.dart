import 'package:flutter/material.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_chart_configuration.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_item.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/balance_bar_chart/balance_bar_chart.dart';

/// Shell for the DayPage
class DayPage extends StatefulWidget {
  /// Creates a DayPage.
  const DayPage({super.key});
  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  @override
  Widget build(BuildContext context) {
    const desiredTime = TimeOfDay(hour: 8, minute: 0);
    const actualTime = TimeOfDay(hour: 9, minute: 0);

    return ListView.builder(
      key: UniqueKey(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return index == 0
            ? BalanceBarChart(
                item: BalanceBarItem(
                  desiredTime: desiredTime,
                  actualTime: actualTime,
                  barDescriptionLabel: 'Actual',
                ),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                barHeight: 45,
                barPadding: 10,
                labelCount: 2,
                style: BalanceBarChartStyle(
                  desiredBalanceColor: const Color(0xff8bc4b7),
                  undesiredBalanceColor: const Color(0xffc85552),
                  barStyle: HorizontalBalanceBarStyle(
                    barTextColor: Colors.black,
                    desiredBarStateColor: const Color(0xfffadeb4),
                    actualUnderHourBarStateColor: const Color(0xff8bc4b7),
                    actualOverHourBarStateColor: const Color(0xffc85552),
                  ),
                  axisLabelColor: Colors.black38,
                  frameColor: Colors.black38,
                ),
              )
            : ListTile(
                title: Text('Day List Tile $index'),
              );
      },
    );
  }
}
