import 'package:flutter/material.dart';

class DiagrammFrameConfiguration {
  static const _labelRowPaddingFactor = 0.15;

  late final double innerDiagramWidth;
  late final double fullDiagramWidth;
  late final double fullDiagramHeight;
  late final double innerDiagramHeight;
  late final double barContainerHeight;
  late final double endLabelCenterWidth;
  final List<({TextPainter painter, Offset offset})> xAxisValues = [];
  late final List<Offset> axisPoints;
  final List<({Offset top, Offset bottom})> verticalHelperLines = [];

  final Color axisLabelColor;
  final Color frameColor;
  DiagrammFrameConfiguration(
      {required List<String> labels,
      required int labelCount,
      required double barHeight,
      required double barPadding,
      required double? width,
      required double constraintsMaxWidth,
      required bool drawVerticalHelperLines,
      required this.axisLabelColor,
      required this.frameColor}) {
    fullDiagramWidth = width != null && width < constraintsMaxWidth
        ? width
        : constraintsMaxWidth;

    barContainerHeight = barHeight + barPadding * 2;

    ({double textWidth, double textCenterWidth, double textHeight}) end =
        _getTextMetaData(labels.last);
    endLabelCenterWidth = end.textCenterWidth;

    ({double textWidth, double textCenterWidth, double textHeight}) origin = (
      textWidth: 0,
      textCenterWidth: 0,
      textHeight: 0,
    );
    if (labelCount > 1) {
      origin = _getTextMetaData(labels.first);
    }

    double labelFieldHeight = _calculateDiagramHeights(end.textHeight);
    _calculateDiagramWidths(fullDiagramWidth, origin.textCenterWidth);
    _configureXAxis(labels, fullDiagramWidth, end.textWidth, origin.textWidth,
        labelCount, labelFieldHeight, drawVerticalHelperLines);
    _configureDiagramFrame(origin.textCenterWidth);
  }

  ({double textWidth, double textCenterWidth, double textHeight})
      _getTextMetaData(String text) {
    TextPainter textPainter = _getTextPainter(text);
    double textWidth = textPainter.width;
    double textCenterWidth = textWidth / 2;
    double textHeight = textPainter.height;
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
      bool drawVerticalHelperLines) {
    for (int i = 0; i < labels.length; i++) {
      String element = labels[i];
      // Calculate the interval between each x-Value
      double interval =
          (parentWidth - endWidth / 2 - originWidth / 2) / (labelCount - 1);
      // Generate the x-Value
      double x = interval * i + originWidth / 2;

      _configureXAxisLabels(element, labelFieldHeight, x);
      _configureVerticalHelperLines(drawVerticalHelperLines, x);
    }
  }

  void _calculateDiagramWidths(
      double parentWidth, double originLabelCenterWidth) {
    innerDiagramWidth =
        parentWidth - originLabelCenterWidth - endLabelCenterWidth;
  }

  void _configureDiagramFrame(double originLabelCenterWidth) {
    axisPoints = [
      Offset(originLabelCenterWidth, 0),
      Offset(originLabelCenterWidth, innerDiagramHeight),
      Offset(xAxisValues.last.offset.dx + xAxisValues.last.painter.width / 2,
          innerDiagramHeight),
    ];
  }

  double _calculateDiagramHeights(double textHeight) {
    double labelFieldHeight = textHeight * (1 + 2 * _labelRowPaddingFactor);
    fullDiagramHeight = barContainerHeight + labelFieldHeight;
    innerDiagramHeight = fullDiagramHeight - labelFieldHeight;

    return labelFieldHeight;
  }

  void _configureXAxisLabels(
      String element, double labelFieldHeight, double x) {
    TextPainter textPainter = _getTextPainter(element);
    double y = barContainerHeight + labelFieldHeight * 0.15;
    double xOffset = textPainter.width / 2;
    Offset offset = Offset(x - xOffset, y);

    xAxisValues.add(
      (
        offset: offset,
        painter: textPainter,
      ),
    );
  }

  void _configureVerticalHelperLines(bool drawVerticalHelperLines, double x) {
    if (drawVerticalHelperLines) {
      verticalHelperLines.add((
        top: Offset(x, 0),
        bottom: Offset(x, innerDiagramHeight),
      ));
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
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    return textPainter;
  }
}
