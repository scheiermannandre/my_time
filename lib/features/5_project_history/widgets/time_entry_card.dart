import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

/// A Card that displays a time entry.
class TimeEntryCard extends StatelessWidget {
  /// Creates a TimeEntryCard.
  const TimeEntryCard({
    required this.timeEntry,
    required this.onClick,
    required this.languageCode,
    super.key,
  });

  /// The time entry to display.
  final TimeEntryModel timeEntry;

  /// The function to call when the card is clicked.
  final VoidCallback? onClick;

  /// The language code.
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: ResponsiveAlign(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeEntry.startTime.toFormattedWeekDayString(languageCode),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                Opacity(
                  opacity: 0.5,
                  child: Row(
                    children: [
                      Text(
                        TimeOfDay.fromDateTime(timeEntry.startTime)
                            .format(context),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        ' - ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        TimeOfDay.fromDateTime(timeEntry.endTime)
                            .format(context),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              timeEntry.totalTime.toFormattedString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
