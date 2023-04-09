import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/domain/time_entry.dart';

class TimeEntryCard extends StatelessWidget {
  final TimeEntryDTO timeEntry;
  final Function? onClick;
  final String languageCode;
  const TimeEntryCard(
      {super.key,
      required this.timeEntry,
      required this.onClick,
      required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick!();
        }
      },
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
                        " - ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        TimeOfDay.fromDateTime(timeEntry.endTime)
                            .format(context),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
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
