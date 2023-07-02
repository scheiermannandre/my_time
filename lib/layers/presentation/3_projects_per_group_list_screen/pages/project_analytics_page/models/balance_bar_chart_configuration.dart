import 'dart:ui';

class BalanceBarChartConfiguration {
  final List<String> labels;
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
    required this.labels,
    required this.labelCount,
    required this.style,
  });
}

class BalanceBarChartStyle {
  final HorizontalBalanceBarStyle barStyle;

  BalanceBarChartStyle({required this.barStyle});
}

class HorizontalBalanceBarStyle {
  final Color desiredBarStateColor;
  final Color actualUnderHourBarStateColor;
  final Color actualOverHourBarStateColor;

  HorizontalBalanceBarStyle({
    required this.desiredBarStateColor,
    required this.actualUnderHourBarStateColor,
    required this.actualOverHourBarStateColor,
  });
}
