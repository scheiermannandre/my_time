import 'package:flutter/material.dart';

/// Holds the configuration for the DiagramFrame.
class DiagrammFrameConfiguration {
  /// Creates a DiagrammFrameConfiguration.
  DiagrammFrameConfiguration({
    required List<String> labels,
    required int labelCount,
    required double barHeight,
    required double barPadding,
    required double? width,
    required double constraintsMaxWidth,
    required bool drawVerticalHelperLines,
    required this.axisLabelColor,
    required this.frameColor,
  }) {
    fullDiagramWidth = width != null && width < constraintsMaxWidth
        ? width
        : constraintsMaxWidth;

    barContainerHeight = barHeight + barPadding * 2;

    final end = _getTextMetaData(labels.last);
    endLabelCenterWidth = end.textCenterWidth;

    var origin = (
      textWidth: 0.0,
      textCenterWidth: 0.0,
      textHeight: 0.0,
    );
    if (labelCount > 1) {
      origin = _getTextMetaData(labels.first);
    }

    final labelFieldHeight = _calculateDiagramHeights(end.textHeight);
    _calculateDiagramWidths(fullDiagramWidth, origin.textCenterWidth);
    _configureXAxis(
      labels,
      fullDiagramWidth,
      end.textWidth,
      origin.textWidth,
      labelCount,
      labelFieldHeight,
      drawVerticalHelperLines,
    );
    _configureDiagramFrame(origin.textCenterWidth);
  }
  static const _labelRowPaddingFactor = 0.15;

  /// The width of the inner diagram.
  late final double innerDiagramWidth;

  /// The width of the full diagram.
  late final double fullDiagramWidth;

  /// The height of the full diagram.
  late final double fullDiagramHeight;

  /// The height of the inner diagram.
  late final double innerDiagramHeight;

  /// The height of the bar container.
  late final double barContainerHeight;

  /// The width of the end label.
  late final double endLabelCenterWidth;

  /// The values of the x-axis.
  final List<({TextPainter painter, Offset offset})> xAxisValues = [];

  /// The points at the axis.
  late final List<Offset> axisPoints;

  /// The vertical helper lines.
  final List<({Offset top, Offset bottom})> verticalHelperLines = [];

  /// The color of the axis labels.
  final Color axisLabelColor;

  /// The color of the frame.
  final Color frameColor;

  ({double textWidth, double textCenterWidth, double textHeight})
      _getTextMetaData(String text) {
    final textPainter = _getTextPainter(text);
    final textWidth = textPainter.width;
    final textCenterWidth = textWidth / 2;
    final textHeight = textPainter.height;
    return (
      textWidth: textWidth,
      textCenterWidth: textCenterWidth,
      textHeight: textHeight
    );
  }

  void _configureXAxis(
    List<String> labels,
    double parentWidth,
    double endWidth,
    double originWidth,
    int labelCount,
    double labelFieldHeight,
    bool drawVerticalHelperLines,
  ) {
    for (var i = 0; i < labels.length; i++) {
      final element = labels[i];
      // Calculate the interval between each x-Value
      final interval =
          (parentWidth - endWidth / 2 - originWidth / 2) / (labelCount - 1);
      // Generate the x-Value
      final x = interval * i + originWidth / 2;

      _configureXAxisLabels(element, labelFieldHeight, x);
      _configureVerticalHelperLines(drawVerticalHelperLines, x);
    }
  }

  void _calculateDiagramWidths(
    double parentWidth,
    double originLabelCenterWidth,
  ) {
    innerDiagramWidth =
        parentWidth - originLabelCenterWidth - endLabelCenterWidth;
  }

  void _configureDiagramFrame(double originLabelCenterWidth) {
    axisPoints = [
      Offset(originLabelCenterWidth, 0),
      Offset(originLabelCenterWidth, innerDiagramHeight),
      Offset(
        xAxisValues.last.offset.dx + xAxisValues.last.painter.width / 2,
        innerDiagramHeight,
      ),
    ];
  }

  double _calculateDiagramHeights(double textHeight) {
    final labelFieldHeight = textHeight * (1 + 2 * _labelRowPaddingFactor);
    fullDiagramHeight = barContainerHeight + labelFieldHeight;
    innerDiagramHeight = fullDiagramHeight - labelFieldHeight;

    return labelFieldHeight;
  }

  void _configureXAxisLabels(
    String element,
    double labelFieldHeight,
    double x,
  ) {
    final textPainter = _getTextPainter(element);
    final y = barContainerHeight + labelFieldHeight * 0.15;
    final xOffset = textPainter.width / 2;
    final offset = Offset(x - xOffset, y);

    xAxisValues.add(
      (
        offset: offset,
        painter: textPainter,
      ),
    );
  }

  void _configureVerticalHelperLines(bool drawVerticalHelperLines, double x) {
    if (drawVerticalHelperLines) {
      verticalHelperLines.add(
        (
          top: Offset(x, 0),
          bottom: Offset(x, innerDiagramHeight),
        ),
      );
    }
  }

  TextPainter _getTextPainter(String text) {
    final textStyle = TextStyle(
      color: axisLabelColor,
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter;
  }
}
