import 'dart:ui';

import 'package:flutter/material.dart';

extension CanvasExtension on Canvas {
  void drawDiagram(List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    drawPoints(PointMode.polygon, points, paint);
  }

  void drawVerticalHelperLines(
      List<({Offset top, Offset bottom})> lines, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (var line in lines) {
      drawLine(Offset(line.top.dx, line.top.dy),
          Offset(line.bottom.dx, line.bottom.dy), paint);
    }
  }

  void drawXAxisValue(TextPainter painter, Offset offset) {
    painter.paint(this, offset);
  }
}
