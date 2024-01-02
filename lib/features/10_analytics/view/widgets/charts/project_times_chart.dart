import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/domain/analytics_domain/models/project_time_model.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bar_chart/horizontal_bar_chart.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

class ProjectTimesChart extends StatelessWidget {
  const ProjectTimesChart({required this.projectTimes, super.key});

  final List<ProjectTimeModel> projectTimes;
  @override
  Widget build(BuildContext context) {
    final maxTime = Duration(
      minutes: projectTimes.map((e) => e.time.inMinutes).reduce(max),
    );
    final projectTimesInHours =
        projectTimes.map((e) => e.time.toHours()).toList();
    final color = ThemeColorBuilder(context).getBodyTextColor();
    final frameColor = ThemeColorBuilder(context).getNonDecorativeBorderColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Times',
          style: TextStyleTokens.body(null),
        ),
        Padding(
          padding: const EdgeInsets.all(SpaceTokens.medium),
          child: HorizontalBarChart(
            barHeight: SpaceTokens.veryLarge,
            barSpacing: SpaceTokens.verySmall,
            verticalBarPadding: const EdgeInsets.only(
              bottom: SpaceTokens.medium,
            ),
            diagramFrameColor: frameColor,
            diagramXAxisLabelStyle: TextStyleTokens.bodyMedium(color)
                .copyWith(fontStyle: FontStyle.italic),
            maxBarValue: maxTime.toHours(),
            barValues: projectTimesInHours,
            drawLabel: (index, value) => maxTime.toFormattedString(),
            drawBars: (index) {
              return BarItem(
                barColor: Theme.of(context).colorScheme.primary,
                label: Text(
                  projectTimes[index].name,
                  style: TextStyleTokens.bodyMedium(color)
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                valueLabel: Text(
                  projectTimes[index].time.toFormattedString(),
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
