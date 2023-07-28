import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

class LabeledBlock extends StatelessWidget {
  final List<TimeEntryModel> timeEntries;
  final Function(TimeEntryModel entry) onClicked;
  final String label;
  final String languageCode;
  const LabeledBlock(
      {super.key,
      required this.timeEntries,
      required this.label,
      required this.onClicked,
      required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
          ),
          TimeEntriesBlock(
            languageCode: languageCode,
            onClick: (entry) => onClicked(entry),
            timeEntries: timeEntries,
          )
        ],
      ),
    );
  }
}
