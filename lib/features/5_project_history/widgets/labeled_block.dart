import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

/// A block of time entries with a label.
class LabeledBlock extends StatelessWidget {
  /// Creates a LabeledBlock.
  const LabeledBlock({
    required this.timeEntries,
    required this.label,
    required this.onClicked,
    required this.languageCode,
    super.key,
  });

  /// The time entries to display.
  final List<TimeEntryModel> timeEntries;

  /// The function to call when a time entry is clicked.
  final void Function(TimeEntryModel entry) onClicked;

  /// The label of the block.
  final String label;

  /// The language code.
  final String languageCode;

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
            onClick: onClicked,
            timeEntries: timeEntries,
          ),
        ],
      ),
    );
  }
}
