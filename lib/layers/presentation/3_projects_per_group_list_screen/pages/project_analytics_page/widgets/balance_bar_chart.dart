import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/diagram_frame_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/diagram_frame.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/horizontal_balance_bar.dart';

class BalanceBarChart extends StatelessWidget {
  static Key balanceBarValueKey = const Key("balanceBarValueKey");

  const BalanceBarChart({
    super.key,
    required this.item,
    required this.barHeight,
    required this.barPadding,
    this.width,
    required this.labelCount,
    required this.style,
    required this.padding,
    this.showVerticalHelperLines = false,
  });

  final BalanceBarItem item;
  final int labelCount;
  final double barHeight;
  final double barPadding;
  final double? width;
  final bool showVerticalHelperLines;
  final BalanceBarChartStyle style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    double tmpActualValue = item.actualTime.toMinutes().toDouble();
    double tmpDesiredValue = item.desiredTime.toMinutes().toDouble();

    double time =
        tmpDesiredValue > tmpActualValue ? tmpDesiredValue : tmpActualValue;
    List<double> slots = generateSlots(time, labelCount);
    List<String> labels = slots.map(formatTime).toList();
    double balanceValue = tmpActualValue - tmpDesiredValue;
    String balanceValueText = formatBalanceTime(balanceValue);

    Color balanceValueTextColor = balanceValue == 0
        ? style.desiredBalanceColor
        : style.undesiredBalanceColor;
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Balance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  key: balanceBarValueKey,
                  balanceValueText,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: balanceValueTextColor),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            LayoutBuilder(
              builder: (context, constraints) {
                final diagramFrame = DiagrammFrameConfiguration(
                  labels: labels,
                  labelCount: labelCount,
                  barHeight: barHeight,
                  barPadding: barPadding,
                  width: width,
                  constraintsMaxWidth: constraints.maxWidth,
                  drawVerticalHelperLines: showVerticalHelperLines,
                  axisLabelColor: style.axisLabelColor,
                  frameColor: style.frameColor,
                );

                return Container(
                  width: diagramFrame.fullDiagramWidth,
                  height: diagramFrame.fullDiagramHeight,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      HorizontalBalanceBar(
                        diagramFrame: diagramFrame,
                        barPadding: barPadding,
                        barContainerHeight: diagramFrame.barContainerHeight,
                        item: item,
                        style: style.barStyle,
                      ),
                      DiagramFrame(diagramFrame: diagramFrame),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
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

  String formatBalanceTime(double time) {
    String char;

    if (time > 0) {
      char = '+';
    } else if (time < 0) {
      char = '-';
      time *= -1;
    } else {
      char = '';
    }
    return '$char${formatTime(time)}';
  }

  String formatTime(double time) {
    int hour = time ~/ 60;
    int minute = time.toInt() % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
