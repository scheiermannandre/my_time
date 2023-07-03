import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/int_extensions.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';

class BalanceBarPainterConfiguration {
  late final double desiredValue;
  late final double value;
  late final Color desiredValueColor;
  late final Color actualValueColor;
  late final String barDescriptionLabel;
  // late final String valueLabel;
  late final TimeOfDay valueTime;

  BalanceBarPainterConfiguration(
      {required BalanceBarItem item,
      required HorizontalBalanceBarStyle style}) {
    barDescriptionLabel = item.barDescriptionLabel;
    valueTime = item.actualTime;
    //valueLabel = item.valueLabel;
    double tmpActualValue = item.actualTime.toMinutes().toDouble();
    double tmpDesiredValue = item.desiredTime.toMinutes().toDouble();

    if (tmpActualValue < tmpDesiredValue) {
      desiredValueColor = style.desiredBarStateColor;
      actualValueColor = style.actualUnderHourBarStateColor;

      value = tmpActualValue / tmpDesiredValue;
    } else if (tmpActualValue == tmpDesiredValue) {
      desiredValueColor = style.desiredBarStateColor;
      actualValueColor = style.desiredBarStateColor;

      value = 1;
    } else {
      desiredValueColor = style.actualOverHourBarStateColor;
      actualValueColor = style.desiredBarStateColor;

      value = tmpDesiredValue / tmpActualValue;
    }
    desiredValue = 1;
  }

  String animatedValueLabel(double animationValue) {
    double animatedValue = valueTime.toMinutes() * animationValue;
    TimeOfDay animatedValueTime = animatedValue.toInt().minutesToTimeOfDay();
    return animatedValueTime.toFormattedString();
  }
}

class BalanceBarPainter extends CustomPainter {
  final BalanceBarPainterConfiguration configuration;
  final double animationValue;

  BalanceBarPainter({
    required this.animationValue,
    required this.configuration,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // draw desired bar
    _drawBar(canvas, size, configuration.desiredValueColor,
        value: configuration.desiredValue * animationValue);
    // draw actual bar
    _drawBar(canvas, size, configuration.actualValueColor,
        value: configuration.value * animationValue, isBelow: false);
    _drawText(
        canvas, size, configuration.barDescriptionLabel, Alignment.centerLeft);
    _drawText(canvas, size, configuration.animatedValueLabel(animationValue),
        Alignment.centerRight);
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
    // assert(value >= 0 && value <= 1);
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
