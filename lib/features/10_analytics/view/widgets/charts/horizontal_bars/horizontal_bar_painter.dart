import 'package:flutter/material.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/diagram_frame/diagram_frame_configuration.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/horizontal_bars/horizontal_bar_config.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

class HorizontalBarPainter extends CustomPainter {
  HorizontalBarPainter({required this.barConfig, required this.frameConfig});

  final HorizontalBarDrawingAreaConfig barConfig;
  final DiagramFrameConfiguration frameConfig;
  @override
  void paint(Canvas canvas, Size size) {
    drawBars(
      canvas,
    );
  }

  void drawBars(
    Canvas canvas,
  ) {
    for (var i = 0; i < barConfig.values.length; i++) {
      final barPaint = barConfig.bars[i].barPaint;

      final barTop = i *
              (barConfig.barHeight +
                  barConfig.barSpacing +
                  barConfig.barLabelHeight) +
          barConfig.verticalBarPaddingTop;
      final barBottom = barTop + barConfig.barHeight;
      final barRight = barConfig.values[i] /
          barConfig.maxBarValue *
          (frameConfig.drawingAreaConfig.size.width);
      final barRRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(
          frameConfig.drawingOffset.dx,
          barTop + barConfig.barLabelHeight,
          barRight + frameConfig.drawingOffset.dx,
          barBottom + barConfig.barLabelHeight,
        ),
        topRight: const Radius.circular(
          SpaceTokens.mediumSmall,
        ), // Adjust the radius as needed
        bottomRight: const Radius.circular(
          SpaceTokens.mediumSmall,
        ), // Adjust the radius as needed
      );

      canvas.drawRRect(barRRect, barPaint);

      drawBarLabels(
        canvas,
        i,
        barTop,
        frameConfig.drawingOffset.dx,
        barRight,
      );
    }
  }

  void drawBarLabels(
    Canvas canvas,
    int index,
    double barTop,
    double barLeft,
    double barRight,
  ) {
    if (barConfig.bars[index].labelPainter.plainText.isNotEmpty) {
      drawText(
        canvas,
        barConfig.bars[index].labelPainter,
        barTop,
      );
    }
    if (barConfig.bars[index].valueLabelPainter.plainText.isNotEmpty) {
      drawText(
        canvas,
        barConfig.bars[index].valueLabelPainter,
        barTop,
        isLeftAligned: false,
      );
    }
  }

  void drawText(
    Canvas canvas,
    TextPainter textPainter,
    double barTop, {
    bool isLeftAligned = true,
  }) {
    // Draw labels above the bars
    textPainter
      ..layout()
      ..paint(
        canvas,
        Offset(
          isLeftAligned
              ? frameConfig.drawingOffset.dx + 8
              : barConfig.size.width +
                  frameConfig.drawingOffset.dx -
                  textPainter.width,

          barTop, // Adjust the offset as needed
        ),
      );
  }

  @override
  bool shouldRepaint(HorizontalBarPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(HorizontalBarPainter oldDelegate) => false;
}
