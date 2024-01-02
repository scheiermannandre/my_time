// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/diagram_frame_painter.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/diagram_frame_configuration.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bars/horizontal_bar_config.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bars/horizontal_bar_painter.dart';

class BarItem {
  BarItem({
    required this.barColor,
    required this.label,
    required this.valueLabel,
  });

  final Text label;
  final Text valueLabel;
  final Color barColor;
}

class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({
    required this.barValues,
    required this.maxBarValue,
    required this.drawBars,
    required this.diagramFrameColor,
    this.labelCount = 1,
    this.barHeight = 48,
    this.diagramXAxisLabelStyle,
    this.barSpacing = 10,
    this.verticalBarPadding,
    this.drawLabel,
    super.key,
  });

  final int labelCount;
  final String Function(int index, double value)? drawLabel;
  final TextStyle? diagramXAxisLabelStyle;
  final Color? diagramFrameColor;
  final BarItem Function(int index)? drawBars;

  final List<double> barValues;
  final double barHeight;
  final double barSpacing;
  final EdgeInsets? verticalBarPadding;
  final double maxBarValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final drawingAreaConfig = HorizontalBarDrawingAreaConfig(
            drawBars: drawBars,
            barHeight: barHeight,
            barSpacing: barSpacing,
            verticalBarPadding: verticalBarPadding,
            values: barValues,
            givenSize: constraints.biggest,
            maxBarValue: maxBarValue,
          );
          final config = DiagramFrameConfiguration(
            drawingAreaConfig: drawingAreaConfig,
            diagramXAxisLabelStyle: diagramXAxisLabelStyle,
            frameColor: diagramFrameColor,
            labelCount: labelCount,
            drawLabel: drawLabel,
          );
          return Stack(
            children: [
              CustomPaint(
                size: config.totalSize,
                painter: HorizontalBarPainter(
                  barConfig: drawingAreaConfig,
                  frameConfig: config,
                ),
                foregroundPainter: DiagramFramePainter(
                  config: config,
                  drawLabel: drawLabel,
                  labelCount: labelCount,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
