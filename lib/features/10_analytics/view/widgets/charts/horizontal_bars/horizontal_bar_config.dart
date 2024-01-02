// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/bar_drawing_area_config.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bar_chart/horizontal_bar_chart.dart';

class BarConfig {
  BarConfig({
    required this.barPaint,
    required this.labelPainter,
    required this.valueLabelPainter,
    required this.value,
  });

  final TextPainter labelPainter;
  final TextPainter valueLabelPainter;
  final Paint barPaint;
  final double value;
}

class HorizontalBarDrawingAreaConfig extends BarDrawingAreaConfig {
  HorizontalBarDrawingAreaConfig({
    required this.barSpacing,
    required this.verticalBarPadding,
    required this.values,
    required this.maxBarValue,
    required Size givenSize,
    required this.barHeight,
    required BarItem Function(int index)? drawBars,
  }) {
    if (drawBars != null) {
      for (var i = 0; i < values.length; i++) {
        final barItem = drawBars(i);
        final labelPainter = calculateLabelHeight(barItem.label);
        final valueLabelPainter = calculateLabelHeight(barItem.valueLabel);
        bars.add(
          BarConfig(
            barPaint: Paint()
              ..color = barItem.barColor
              ..style = PaintingStyle.fill,
            labelPainter: labelPainter,
            valueLabelPainter: valueLabelPainter,
            value: values[i],
          ),
        );
      }
    }
    calculateBarDrawingAreaSize(givenSize);
  }

  void calculateBarDrawingAreaSize(Size givenSize) {
    final barDrawingHeight = values.length * (barHeight + barLabelHeight) +
        (values.length - 1) * barSpacing +
        verticalBarPaddingSum;

    adjustSize(Size(givenSize.width, barDrawingHeight));
  }

  final double barHeight;
  final double barSpacing;
  final EdgeInsets? verticalBarPadding;

  double get verticalBarPaddingSum {
    if (verticalBarPadding == null) return 0;
    return verticalBarPadding!.top + verticalBarPadding!.bottom;
  }

  double get verticalBarPaddingTop {
    if (verticalBarPadding == null) return 0;
    return verticalBarPadding!.top;
  }

  double get verticalBarPaddingBottom {
    if (verticalBarPadding == null) return 0;
    return verticalBarPadding!.bottom;
  }

  double barLabelHeight = 0;

  final double maxBarValue;
  final List<double> values;
  final List<BarConfig> bars = [];

  TextPainter calculateLabelHeight(Text text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text.data,
        style: text.style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    if (textPainter.height > barLabelHeight) {
      barLabelHeight = textPainter.height;
    }
    return textPainter;
  }
}
