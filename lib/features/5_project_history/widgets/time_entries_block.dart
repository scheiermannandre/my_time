import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/global/globals.dart';

/// The block with time entries.
class TimeEntriesBlock extends StatelessWidget {
  /// Creates a TimeEntriesBlock.
  const TimeEntriesBlock({
    required this.timeEntries,
    required this.onClick,
    required this.languageCode,
    super.key,
  });

  /// The time entries to display.
  final List<TimeEntryModel> timeEntries;

  /// The function to call when a time entry is clicked.
  final void Function(TimeEntryModel entry) onClick;

  /// The language code.
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GlobalProperties.shadowColor,
              blurRadius: 1, // soften the shadow
            ),
          ],
          color: Colors.white,
          border: Border.all(
            color: GlobalProperties.shadowColor,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timeEntries.length,
          itemBuilder: (context, index) => TimeEntryCard(
            languageCode: languageCode,
            onClick: () {
              onClick(timeEntries[index]);
            },
            timeEntry: timeEntries[index],
          ),
          separatorBuilder: (context, index) => Divider(
            color: GlobalProperties.shadowColor,
            height: 1,
          ),
        ),
      ),
    );
  }
}
