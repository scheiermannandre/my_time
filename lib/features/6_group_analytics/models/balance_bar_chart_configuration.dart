import 'dart:ui';

/// Configuration for the BalanceBarChart.
class BalanceBarChartConfiguration {
  /// Creates a [BalanceBarChartConfiguration].
  BalanceBarChartConfiguration({
    required this.barHeight,
    required this.barPadding,
    required this.labelCount,
    required this.style,
    this.width,
  });

  /// The number of labels to display on the x-axis.
  final int labelCount;

  /// The height of the bars.
  final double barHeight;

  /// The padding between the bars.
  final double barPadding;

  /// The width of the chart.
  final double? width;

  /// Indicates whether the vertical helper lines should be displayed.
  final bool showVerticalHelperLines = false;

  /// The style of the chart.
  final BalanceBarChartStyle style;
}

/// The style of the BalanceBarChart.
class BalanceBarChartStyle {
  /// Creates a [BalanceBarChartStyle].
  BalanceBarChartStyle({
    required this.barStyle,
    required this.desiredBalanceColor,
    required this.undesiredBalanceColor,
    required this.axisLabelColor,
    required this.frameColor,
  });

  /// The horizontal bar style.
  final HorizontalBalanceBarStyle barStyle;

  /// The color of the desired balance.
  final Color desiredBalanceColor;

  /// The color of the undesired balance.
  final Color undesiredBalanceColor;

  /// The color of the axis labels.
  final Color axisLabelColor;

  /// The color of the frame.
  final Color frameColor;
}

/// The style of the horizontal bars.
class HorizontalBalanceBarStyle {
  /// Creates a [HorizontalBalanceBarStyle].
  HorizontalBalanceBarStyle({
    required this.desiredBarStateColor,
    required this.actualUnderHourBarStateColor,
    required this.actualOverHourBarStateColor,
    required this.barTextColor,
  });

  /// The color of the desired bar state.
  final Color desiredBarStateColor;

  /// The color of the actual under hour bar state.
  final Color actualUnderHourBarStateColor;

  /// The color of the actual over hour bar state.
  final Color actualOverHourBarStateColor;

  /// The color of the bar text.
  final Color barTextColor;
}
