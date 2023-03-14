import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/global/globals.dart';

class TimeEntryCard extends StatelessWidget {
  final TimeEntry timeEntry;
  final Function? onClick;
  const TimeEntryCard({super.key, required this.timeEntry, required this.onClick});

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
                Text(timeEntry.startTime.toFormattedWeekDayString(),
                    style: const TextStyle(fontSize: 18)),
                const Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                Row(
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(timeEntry.startTime)
                          .format(context),
                      style: TextStyle(
                          fontSize: 14,
                          color: GlobalProperties.textAndIconColor
                              .withOpacity(.5)),
                    ),
                    Text(
                      " - ",
                      style: TextStyle(
                          fontSize: 14,
                          color: GlobalProperties.textAndIconColor
                              .withOpacity(.5)),
                    ),
                    Text(
                      TimeOfDay.fromDateTime(timeEntry.endTime).format(context),
                      style: TextStyle(
                          fontSize: 14,
                          color: GlobalProperties.textAndIconColor
                              .withOpacity(.5)),
                    ),
                  ],
                )
              ],
            ),
            Text(timeEntry.totalTime.toFormattedString(),
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
