import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/time_entries_block.dart';

class LabeledBlock extends StatelessWidget {
  final List<TimeEntry> timeEntries;
  final Function(TimeEntry entry) onClicked;
  final String label;
  const LabeledBlock(
      {super.key,
      required this.timeEntries,
      required this.label,
      required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
          ),
          TimeEntriesBlock(
            onClick: (entry) => onClicked(entry),
            timeEntries: timeEntries,
          )
        ],
      ),
    );
  }
}
