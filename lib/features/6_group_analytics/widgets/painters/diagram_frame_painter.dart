import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/canvas_extensions.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';

class DiagramFramePainter extends CustomPainter {
  final DiagrammFrameConfiguration configuration;

  DiagramFramePainter({
    required this.configuration,
  });
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDiagram(configuration.axisPoints, configuration.frameColor);
    canvas.drawVerticalHelperLines(
        configuration.verticalHelperLines, configuration.frameColor);
    for (var element in configuration.xAxisValues) {
      canvas.drawXAxisValue(element.painter, element.offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
