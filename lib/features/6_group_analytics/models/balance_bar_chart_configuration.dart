import 'dart:ui';

class BalanceBarChartConfiguration {
  final int labelCount;
  final double barHeight;
  final double barPadding;
  final double? width;
  final bool showVerticalHelperLines = false;
  final BalanceBarChartStyle style;

  BalanceBarChartConfiguration({
    required this.barHeight,
    required this.barPadding,
    this.width,
    required this.labelCount,
    required this.style,
  });
}

class BalanceBarChartStyle {
  final HorizontalBalanceBarStyle barStyle;
  final Color desiredBalanceColor;
  final Color undesiredBalanceColor;
  final Color axisLabelColor;
  final Color frameColor;

  BalanceBarChartStyle({
    required this.barStyle,
    required this.desiredBalanceColor,
    required this.undesiredBalanceColor,
    required this.axisLabelColor,
    required this.frameColor,
  });
}

class HorizontalBalanceBarStyle {
  final Color desiredBarStateColor;
  final Color actualUnderHourBarStateColor;
  final Color actualOverHourBarStateColor;
  final Color barTextColor;
  HorizontalBalanceBarStyle({
    required this.desiredBarStateColor,
    required this.actualUnderHourBarStateColor,
    required this.actualOverHourBarStateColor,
    required this.barTextColor,
  });
}
