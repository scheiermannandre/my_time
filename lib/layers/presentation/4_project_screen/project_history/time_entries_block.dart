import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/time_entry_card.dart';
import 'package:my_time/global/globals.dart';

class TimeEntriesBlock extends StatelessWidget {
  final List<TimeEntry> timeEntries;
  final Function(TimeEntry entry) onClick;

  const TimeEntriesBlock(
      {super.key, required this.timeEntries, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GlobalProperties.shadowColor,
              blurRadius: 1.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
            )
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
