import 'package:my_time/common/common.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/global/globals.dart';

import 'package:flutter/material.dart';

class TimeEntriesBlock extends StatelessWidget {
  final List<TimeEntryModel> timeEntries;
  final Function(TimeEntryModel entry) onClick;
  final String languageCode;

  const TimeEntriesBlock(
      {super.key,
      required this.timeEntries,
      required this.onClick,
      required this.languageCode});

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
