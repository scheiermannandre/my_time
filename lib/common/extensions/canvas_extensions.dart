import 'dart:ui';

import 'package:flutter/material.dart';

extension CanvasExtension on Canvas {
  void drawDiagram(List<Offset> points) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    drawPoints(PointMode.polygon, points, paint);
  }

  void drawVerticalHelperLines(List<({Offset top, Offset bottom})> lines) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    for (var line in lines) {
      drawLine(line.top, line.bottom, paint);
    }
  }

  void drawXAxisValue(TextPainter painter, Offset offset) {
    painter.paint(this, offset);
  }
}
