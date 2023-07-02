import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/balance_bar_chart.dart';

///
/// Shell for the DayPage
class DayPage extends StatefulWidget {
  const DayPage({super.key});
  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  @override
  Widget build(BuildContext context) {
    int labelCount = 2;
    List<double> slots = generateSlots(
        const TimeOfDay(hour: 9, minute: 0).toMinutes().toDouble(), labelCount);
    List<String> labels = slots.map(formatTime).toList();
    return ListView.builder(
      key: UniqueKey(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return index == 0
            ? BalanceBarChart(
                item: BalanceBarItem(
                    desiredValue: 1,
                    value: .5,
                    label: 'Actual',
                    valueLabel: '07:00'),
                configuration: BalanceBarChartConfiguration(
                  barHeight: 45,
                  barPadding: 10,
                  labels: labels,
                  labelCount: labelCount,
                  style: BalanceBarChartStyle(
                    barStyle: HorizontalBalanceBarStyle(
                        desiredBarStateColor: Colors.red,
                        actualUnderHourBarStateColor: Colors.green,
                        actualOverHourBarStateColor: Colors.blue),
                  ),
                ),
              )
            : ListTile(
                title: Text('Day List Tile $index'),
              );
      },
    );
  }

  List<double> generateSlots(double timeOfDay, int count) {
    List<double> timeList = [];

    // Handle count = 1 separately
    if (count == 1) {
      timeList.add(timeOfDay);
      return timeList;
    }
    // Calculate the interval between each time slot
    double interval = timeOfDay / (count - 1);

    // Generate the time slots
    for (int i = 0; i < count; i++) {
      double slotTime = interval * i;
      timeList.add(slotTime);
    }

    return timeList;
  }

  String formatTime(double time) {
    int hour = time ~/ 60;
    int minute = time.toInt() % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
