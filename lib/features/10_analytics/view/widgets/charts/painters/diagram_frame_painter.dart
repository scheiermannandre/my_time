import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/canvas_extensions.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';

/// The painter for the DiagramFrame.
class DiagramFramePainter extends CustomPainter {
  /// Creates a DiagramFramePainter.
  DiagramFramePainter({
    required this.configuration,
  });

  /// The configuration of the painter.
  final DiagrammFrameConfiguration configuration;
  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..drawDiagram(configuration.axisPoints, configuration.frameColor)
      ..drawVerticalHelperLines(
        configuration.verticalHelperLines,
        configuration.frameColor,
      );
    for (final element in configuration.xAxisValues) {
      canvas.drawXAxisValue(element.painter, element.offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
