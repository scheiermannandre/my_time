import 'package:flutter/material.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/diagram_frame_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/painters/diagram_frame_painter.dart';

class DiagramFrame extends StatelessWidget {
  const DiagramFrame({super.key, required this.diagramFrame});
  final DiagrammFrameConfiguration diagramFrame;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: diagramFrame.innerDiagramWidth,
      height: diagramFrame.fullDiagramHeight,
      color: Colors.transparent,
      child: CustomPaint(
        painter: DiagramFramePainter(configuration: diagramFrame),
      ),
    );
  }
}
