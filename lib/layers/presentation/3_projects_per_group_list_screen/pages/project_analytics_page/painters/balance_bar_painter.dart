import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';

class BalanceBarPainter extends CustomPainter {
  final BalanceBarItem item;
  final double animationValue;

  BalanceBarPainter({required this.item, required this.animationValue});
  @override
  void paint(Canvas canvas, Size size) {
    _drawBar(canvas, size, GlobalProperties.primaryColor,
        value: item.desiredValue * animationValue);
    _drawBar(canvas, size, const Color(0xFF256B6F),
        value: item.value * animationValue, isBelow: false);
    _drawText(canvas, size, item.label, Alignment.centerLeft);
    _drawText(canvas, size, item.valueLabel, Alignment.centerRight);
  }

  void _drawText(
      Canvas canvas, Size size, String barDescription, Alignment alignment) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: barDescription,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = alignment == Alignment.centerLeft
        ? 10.0
        : size.width - textPainter.width - 10.0;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  void _drawBar(Canvas canvas, Size size, Color color,
      {required double value, bool isBelow = true}) {
    assert(value >= 0 && value <= 1);
    final verticalRadiusRight =
        value == 1 ? const Radius.circular(0) : const Radius.circular(0);
    const verticalRadiusLeft = Radius.circular(0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width * value,
      size.height,
      topLeft: verticalRadiusLeft,
      bottomRight: verticalRadiusRight,
      topRight: verticalRadiusRight,
      bottomLeft: verticalRadiusLeft,
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
