import 'package:flutter/material.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/diagram_frame_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/diagram_frame.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/horizontal_balance_bar.dart';

class BalanceBarChart extends StatelessWidget {
  const BalanceBarChart({
    super.key,
    required this.item,
    required this.configuration,
  });

  final BalanceBarItem item;
  final BalanceBarChartConfiguration configuration;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final diagramFrame = DiagrammFrameConfiguration(
            labels: configuration.labels,
            labelCount: configuration.labelCount,
            barHeight: configuration.barHeight,
            barPadding: configuration.barPadding,
            width: configuration.width,
            constraintsMaxWidth: constraints.maxWidth,
            drawVerticalHelperLines: configuration.showVerticalHelperLines,
          );

          return Container(
            width: diagramFrame.fullDiagramWidth,
            height: diagramFrame.fullDiagramHeight,
            color: Colors.transparent,
            child: Stack(
              children: [
                HorizontalBalanceBar(
                  diagramFrame: diagramFrame,
                  barPadding: configuration.barPadding,
                  barContainerHeight: diagramFrame.barContainerHeight,
                  item: item,
                  style: configuration.style.barStyle,
                ),
                DiagramFrame(diagramFrame: diagramFrame),
              ],
            ),
          );
        },
      ),
    );
  }
}
