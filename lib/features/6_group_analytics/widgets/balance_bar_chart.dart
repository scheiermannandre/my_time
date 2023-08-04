import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_chart_configuration.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_item.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';
import 'package:my_time/features/6_group_analytics/widgets/diagram_frame.dart';
import 'package:my_time/features/6_group_analytics/widgets/horizontal_balance_bar.dart';

/// The BalanceBarChart.
class BalanceBarChart extends StatelessWidget {
  /// Creates a BalanceBarChart.
  const BalanceBarChart({
    required this.item,
    required this.barHeight,
    required this.barPadding,
    required this.labelCount,
    required this.style,
    required this.padding,
    super.key,
    this.width,
    this.showVerticalHelperLines = false,
  });

  /// Key for the balance bar value.
  static Key balanceBarValueKey = const Key('balanceBarValueKey');

  /// The item of the BalanceBarChart.
  final BalanceBarItem item;

  /// The count of the labels.
  final int labelCount;

  /// The height of the bar.
  final double barHeight;

  /// The padding of the bar.
  final double barPadding;

  /// The width of the bar.
  final double? width;

  /// Whether to show the vertical helper lines.
  final bool showVerticalHelperLines;

  /// The style of the BalanceBarChart.
  final BalanceBarChartStyle style;

  /// The padding of the BalanceBarChart.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final tmpActualValue = item.actualTime.toMinutes().toDouble();
    final tmpDesiredValue = item.desiredTime.toMinutes().toDouble();

    final time =
        tmpDesiredValue > tmpActualValue ? tmpDesiredValue : tmpActualValue;
    final slots = _generateSlots(time, labelCount);
    final labels = slots.map(_formatTime).toList();
    final balanceValue = tmpActualValue - tmpDesiredValue;
    final balanceValueText = _formatBalanceTime(balanceValue);

    final balanceValueTextColor = balanceValue == 0
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
                  'Balance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  key: balanceBarValueKey,
                  balanceValueText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: balanceValueTextColor,
                  ),
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

  List<double> _generateSlots(double timeOfDay, int count) {
    final timeList = <double>[];

    // Handle count = 1 separately
    if (count == 1) {
      timeList.add(timeOfDay);
      return timeList;
    }
    // Calculate the interval between each time slot
    final interval = timeOfDay / (count - 1);

    // Generate the time slots
    for (var i = 0; i < count; i++) {
      final slotTime = interval * i;
      timeList.add(slotTime);
    }

    return timeList;
  }

  String _formatBalanceTime(double time) {
    String char;
    var localTime = time;
    if (localTime > 0) {
      char = '+';
    } else if (localTime < 0) {
      localTime *= -1;
      char = '-';
    } else {
      char = '';
    }
    return '$char${_formatTime(localTime)}';
  }

  String _formatTime(double time) {
    final hour = time ~/ 60;
    final minute = time.toInt() % 60;
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}
