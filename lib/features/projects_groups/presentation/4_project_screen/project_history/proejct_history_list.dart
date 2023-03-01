import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/features/projects_groups/data/projects_repository.dart';
import 'package:my_time/features/projects_groups/domain/time_entry.dart';
import 'package:my_time/features/projects_groups/presentation/4_project_screen/project_history/labeled_block.dart';

class ProjectHistory extends StatelessWidget {
  final Function(TimeEntry id, ) onClicked;

  const ProjectHistory({super.key, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final timeEntriesList = ref.watch(projectTimeEntriesProvider(""));
        return AsyncValueWidget(
          value: timeEntriesList,
          data: (timeEntries) => timeEntries!.isEmpty
              ? Center(
                  child: Text(
                    'No projects found',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                )
              : SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: timeEntries.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return LabeledBlock(
                        onClicked: (entry) => onClicked(entry),
                        timeEntries: timeEntries[index],
                        label: timeEntries[index]
                            .first
                            .startTime
                            .toMonthAndYearString(),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
