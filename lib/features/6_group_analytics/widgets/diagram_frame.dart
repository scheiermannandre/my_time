import 'package:flutter/material.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';
import 'package:my_time/features/6_group_analytics/widgets/painters/diagram_frame_painter.dart';

/// The DiagramFrame.
class DiagramFrame extends StatelessWidget {
  /// Creates a DiagramFrame.
  const DiagramFrame({required this.diagramFrame, super.key});

  /// The configuration of the DiagramFrame.
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
