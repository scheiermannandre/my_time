// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/bar_drawing_area_config.dart';

class DiagramFrameConfiguration {
  DiagramFrameConfiguration({
    required this.drawingAreaConfig,
    required int labelCount,
    required String Function(int index, double value)? drawLabel,
    required TextStyle? diagramXAxisLabelStyle,
    Color? frameColor,
  }) {
    this.frameColor = frameColor ?? Colors.black;
    _labels =
        generateXAxisLabels(labelCount, drawLabel, diagramXAxisLabelStyle);
    final labelHeight = calculateLabelHeight();

    _totalSize = Size(
      drawingAreaConfig.size.width,
      drawingAreaConfig.size.height + labelHeight,
    );

    final adjustments =
        adjustXAxisSizeWhenLabels(drawingAreaConfig.size, _labels);

    drawingAreaConfig.adjustSize(adjustments.newSize);
    _offset = adjustments.offset;
  }
  late final Color frameColor;
  final BarDrawingAreaConfig drawingAreaConfig;
  late Size _totalSize;
  Size get totalSize => _totalSize;

  late Offset _offset;
  Offset get drawingOffset => _offset;

  late List<TextPainter> _labels;
  List<TextPainter> get labels => _labels;

  bool get drawVerticalHelperLines => labels.isNotEmpty;

  List<TextPainter> generateXAxisLabels(
    int labelCount,
    String Function(int index, double value)? drawLabel,
    TextStyle? style,
  ) {
    if (drawLabel == null) return [];
    return List.generate(labelCount, (index) {
      var label = '';
      if (labelCount == 1) {
        label = drawLabel(index, 1);
      } else {
        final valueFraction = labelCount == 2 ? 1.0 : 1 / (labelCount - 1);
        label = drawLabel(index, valueFraction * index);
      }
      return TextPainter(
        text: TextSpan(
          text: label,
          style: style,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    });
  }

  double calculateLabelHeight() {
    if (labels.isEmpty) return 0;
    return max(labels.first.height, labels.last.height);
  }

  ({Size newSize, Offset offset}) adjustXAxisSizeWhenLabels(
    Size givenSize,
    List<TextPainter> labels,
  ) {
    if (labels.length <= 1) return (newSize: givenSize, offset: Offset.zero);

    // Calculate the width of the first and last labels
    final firstLabelPainter = labels.first;

    final lastLabelPainter = labels.last;

    // Adjust the size of the diagram frame based on the width of
    // the first and last labels
    var adjustedWidth = givenSize.width;
    var adjustedDx = 0.0;
    if (labels.length >= 2) {
      adjustedWidth -= firstLabelPainter.width / 2;
      adjustedDx = firstLabelPainter.width / 2;
    }
    adjustedWidth -= lastLabelPainter.width / 2;

    return (
      newSize: Size(adjustedWidth, givenSize.height),
      offset: Offset(adjustedDx, 0)
    );
  }

  ({Size newSize, Offset offset}) adjustHeightWhenHorizontalBars({
    required Size size,
    required Offset offset,
    required int barCount,
    double? barHeight,
    double barSpacing = 0,
    double verticalBarPadding = 0,
  }) {
    final localBarHeight =
        getBarHeight(barHeight, size, verticalBarPadding, barCount, barSpacing);

    // Calculate the total height of the bars including space between the bars
    final totalHeight = barCount * (localBarHeight + barSpacing) -
        barSpacing +
        2 * verticalBarPadding;
    final adjustedSize = Size(size.width, totalHeight);
    return (newSize: adjustedSize, offset: offset);
  }

  double getBarHeight(
    double? barHeight,
    Size size,
    double verticalBarPadding,
    int barCount,
    double barSpacing,
  ) {
    var localBarHeight = barHeight ?? 0.0;

    if (barHeight == null) {
      localBarHeight =
          (size.height - 2 * verticalBarPadding - (barCount - 1) * barSpacing) /
              barCount;
    }
    return localBarHeight;
  }
}
