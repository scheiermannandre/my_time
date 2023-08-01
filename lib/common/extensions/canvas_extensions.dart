import 'dart:ui';
import 'package:flutter/material.dart';

/// Extension for the [Canvas] class.
extension CanvasExtension on Canvas {
  /// Draws lines to create a diagram frame with x- and y-axis.
  void drawDiagram(List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    drawPoints(PointMode.polygon, points, paint);
  }

  /// Draws vertical lines that extend the axis value lines, so that the user
  /// can easier grasp the values of certain horizontal bars.
  void drawVerticalHelperLines(
    List<({Offset top, Offset bottom})> lines,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (final line in lines) {
      drawLine(
        Offset(line.top.dx, line.top.dy),
        Offset(line.bottom.dx, line.bottom.dy),
        paint,
      );
    }
  }

  /// Draws the x-axis values.
  void drawXAxisValue(TextPainter painter, Offset offset) {
    painter.paint(this, offset);
  }
}
