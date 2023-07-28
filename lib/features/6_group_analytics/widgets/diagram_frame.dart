import 'package:flutter/material.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';
import 'package:my_time/features/6_group_analytics/widgets/painters/diagram_frame_painter.dart';

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
