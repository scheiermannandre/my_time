import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/int_extensions.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_chart_configuration.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_item.dart';

/// The painter for the BalanceBarChart.
class BalanceBarPainterConfiguration {
  /// Creates a BalanceBarPainterConfiguration.
  BalanceBarPainterConfiguration({
    required BalanceBarItem item,
    required HorizontalBalanceBarStyle style,
  }) {
    barTextColor = style.barTextColor;
    barDescriptionLabel = item.barDescriptionLabel;
    valueTime = item.actualTime;
    //valueLabel = item.valueLabel;
    final tmpActualValue = item.actualTime.toMinutes().toDouble();
    final tmpDesiredValue = item.desiredTime.toMinutes().toDouble();

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

  /// The value of the desired bar.
  late final double desiredValue;

  /// The value of the actual bar.
  late final double value;

  /// The color of the desired bar.
  late final Color desiredValueColor;

  /// The color of the actual bar.
  late final Color actualValueColor;

  /// The color of the text.
  late final Color barTextColor;

  /// The description of the bar.
  late final String barDescriptionLabel;

  /// The value of the actual bar.
  late final TimeOfDay valueTime;

  String _animatedValueLabel(double animationValue) {
    final animatedValue = valueTime.toMinutes() * animationValue;
    final animatedValueTime = animatedValue.toInt().minutesToTimeOfDay();
    return animatedValueTime.toFormattedString();
  }
}

/// The painter for the BalanceBarChart.
class BalanceBarPainter extends CustomPainter {
  /// Creates a BalanceBarPainter.
  BalanceBarPainter({
    required this.animationValue,
    required this.configuration,
  });

  /// The configuration of the painter.
  final BalanceBarPainterConfiguration configuration;

  /// The animation value.
  final double animationValue;
  @override
  void paint(Canvas canvas, Size size) {
    // draw desired bar
    _drawBar(
      canvas,
      size,
      configuration.desiredValueColor,
      value: configuration.desiredValue * animationValue,
    );
    // draw actual bar
    _drawBar(
      canvas,
      size,
      configuration.actualValueColor,
      value: configuration.value * animationValue,
      isBelow: false,
    );
    _drawText(
      canvas,
      size,
      configuration.barDescriptionLabel,
      Alignment.centerLeft,
    );
    _drawText(
      canvas,
      size,
      configuration._animatedValueLabel(animationValue),
      Alignment.centerRight,
    );
  }

  void _drawText(
    Canvas canvas,
    Size size,
    String barDescription,
    Alignment alignment,
  ) {
    final textStyle = TextStyle(
      color: configuration.barTextColor,
      fontSize: 20,
    );
    final textSpan = TextSpan(
      text: barDescription,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: size.width,
      );
    final xCenter = alignment == Alignment.centerLeft
        ? 10.0
        : size.width - textPainter.width - 10.0;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  void _drawBar(
    Canvas canvas,
    Size size,
    Color color, {
    required double value,
    bool isBelow = true,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width * value,
      size.height,
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
