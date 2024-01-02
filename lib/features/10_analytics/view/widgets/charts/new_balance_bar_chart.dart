// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bar_chart/horizontal_bar_chart.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

class NewBalanceBarChart extends StatelessWidget {
  const NewBalanceBarChart({
    required this.expectedTime,
    required this.actualTime,
    super.key,
  });
  final Duration expectedTime;
  final Duration actualTime;

  @override
  Widget build(BuildContext context) {
    final data = <({String label, String valueLabel, Color color})>[];
    final barValues = <double>[];

    final maxValue = expectedTime > actualTime ? expectedTime : actualTime;

    final balanceValueText = (actualTime - expectedTime).toFormattedString();

    Color? balanceValueTextColor;
    barValues.add(expectedTime.toHours());
    data.add(
      (
        label: 'Expected',
        valueLabel: expectedTime.toFormattedString(),
        color: Theme.of(context).colorScheme.primary
      ),
    );
    if (expectedTime != actualTime) {
      barValues.add(actualTime.toHours());
      if (expectedTime > actualTime) {
        balanceValueTextColor = ThemelessColorTokens.undesired;
      } else if (expectedTime < actualTime) {
        balanceValueTextColor = ThemelessColorTokens.desired;
      }
      data.add(
        (
          label: 'Actual',
          valueLabel: actualTime.toFormattedString(),
          color: balanceValueTextColor!
        ),
      );
    }
    final color = ThemeColorBuilder(context).getBodyTextColor();
    final frameColor = ThemeColorBuilder(context).getNonDecorativeBorderColor();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Balance',
              style: TextStyleTokens.body(null),
            ),
            Padding(
              padding: const EdgeInsets.only(right: SpaceTokens.mediumSmall),
              child: Text(
                balanceValueText,
                style: TextStyleTokens.body(null).copyWith(
                  color: balanceValueTextColor,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(SpaceTokens.medium),
          child: HorizontalBarChart(
            barHeight: SpaceTokens.veryLarge,
            barSpacing: SpaceTokens.verySmall,
            verticalBarPadding: const EdgeInsets.only(
              bottom: SpaceTokens.medium,
            ),
            maxBarValue: maxValue.toHours(),
            barValues: barValues,
            drawLabel: (index, value) {
              return maxValue.toFormattedString();
            },
            diagramFrameColor: frameColor,
            diagramXAxisLabelStyle: TextStyleTokens.bodyMedium(color)
                .copyWith(fontStyle: FontStyle.italic),
            drawBars: (index) {
              return BarItem(
                barColor: data[index].color,
                label: Text(
                  data[index].label,
                  style: TextStyleTokens.bodyMedium(color)
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                valueLabel: Text(
                  data[index].valueLabel,
                  style: TextStyleTokens.bodyMedium(color)
                      .copyWith(fontStyle: FontStyle.italic),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
