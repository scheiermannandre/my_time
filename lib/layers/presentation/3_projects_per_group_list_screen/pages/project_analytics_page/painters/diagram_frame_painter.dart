import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/canvas_extensions.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/diagram_frame_configuration.dart';

class DiagramFramePainter extends CustomPainter {
  final DiagrammFrameConfiguration configuration;

  DiagramFramePainter({
    required this.configuration,
  });
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDiagram(configuration.axisPoints);
    canvas.drawVerticalHelperLines(configuration.verticalHelperLines);
    for (var element in configuration.xAxisValues) {
      canvas.drawXAxisValue(element.painter, element.offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
