import 'package:flutter/material.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/diagram_frame_configuration.dart';

class DiagramFramePainter extends CustomPainter {
  DiagramFramePainter({
    required this.drawLabel,
    required this.labelCount,
    required this.config,
  });
  final String Function(int index, double value)? drawLabel;
  final int labelCount;
  final DiagramFrameConfiguration config;
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.0;
    final paint = Paint()
      ..color = config.frameColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    drawLabelsAndLines(
      canvas,
      paint,
    );
    drawAxis(canvas, paint);
  }

  void drawAxis(
    Canvas canvas,
    Paint paint,
  ) {
    // Draw x-axis
    final xAxis = Offset(
      0 + config.drawingOffset.dx,
      config.drawingAreaConfig.size.height,
    );
    final xAxisEnd = Offset(
      config.drawingAreaConfig.size.width + config.drawingOffset.dx,
      config.drawingAreaConfig.size.height,
    );
    canvas.drawLine(xAxis, xAxisEnd, paint);

    //Draw y-axis
    final yAxis = Offset(0 + config.drawingOffset.dx, 0);
    final yAxisEnd = Offset(
      0 + config.drawingOffset.dx,
      config.drawingAreaConfig.size.height,
    );
    canvas.drawLine(yAxis, yAxisEnd, paint);
  }

  void drawLabelsAndLines(
    Canvas canvas,
    Paint paint,
  ) {
    if (config.labels.isEmpty) return;
    // Draw x-axis labels and lines

    for (var i = 0; i < labelCount; i++) {
      final labelPainter = config.labels[i];

      var labelX = 0.0;
      var centeredLabelX = 0.0;
      if (labelCount == 1) {
        labelX = config.drawingAreaConfig.size.width;
        centeredLabelX = labelX - labelPainter.width;
      } else {
        labelX = (config.drawingAreaConfig.size.width / (labelCount - 1)) * i;
        centeredLabelX = labelX - (labelPainter.width / 2);
      }

      labelPainter.paint(
        canvas,
        Offset(
          centeredLabelX + config.drawingOffset.dx,
          config.drawingAreaConfig.size.height + 5,
        ),
      );

      if (config.drawVerticalHelperLines) {
        // Draw line
        final lineOffsetStart = Offset(
          labelX + config.drawingOffset.dx,
          config.drawingAreaConfig.size.height,
        );
        final lineOffsetEnd = Offset(
          labelX + config.drawingOffset.dx,
          config.drawingAreaConfig.size.height + 5,
        );
        canvas.drawLine(lineOffsetStart, lineOffsetEnd, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DiagramFramePainter oldDelegate) {
    return false;
  }
}
