import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/spaced_row.dart';

/// A widget that displays the time data in a responsive way.
class ResponsiveTimeData extends StatelessWidget {
  /// Creates a [ResponsiveTimeData].
  const ResponsiveTimeData({
    required this.startTimeWidget,
    required this.endTimeWidget,
    required this.breakTimeWidget,
    required this.totalTimeWidget,
    super.key,
  });

  /// The widget to display the start time.
  final Widget startTimeWidget;

  /// The widget to display the end time.
  final Widget endTimeWidget;

  /// The widget to display the break time.
  final Widget breakTimeWidget;

  /// The widget to display the total time.
  final Widget totalTimeWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 360) {
          return SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: SpaceTokens.medium,
            children: [
              startTimeWidget,
              endTimeWidget,
              breakTimeWidget,
              totalTimeWidget,
            ],
          );
        } else {
          return Column(
            children: [
              SpacedRow(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: SpaceTokens.medium,
                children: [
                  startTimeWidget,
                  breakTimeWidget,
                ],
              ),
              SpacedRow(
                spacing: SpaceTokens.medium,
                children: [
                  endTimeWidget,
                  totalTimeWidget,
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
