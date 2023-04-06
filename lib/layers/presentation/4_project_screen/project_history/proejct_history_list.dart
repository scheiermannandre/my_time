import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/labeled_block.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';

class ProjectHistory extends HookConsumerWidget {
  final ProjectDTO project;

  const ProjectHistory({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectScreenController =
        ref.watch(projectScreenControllerProvider.notifier);
    final projectScreenState = ref.watch(projectScreenControllerProvider);

    final timeEntriesList = ref.watch(projectTimeEntriesProvider(project.id));
    return timeEntriesList.when(
      data: (data) => data!.isEmpty
          ? NoItemsFoundWidget(
              onBtnTap: () => !projectScreenState.isLoading
                  ? projectScreenController.pushNamedTimeEntryForm(
                      context,
                      project,
                    )
                  : null,
              title: "No history available",
              description: "Click on the button below to add a new Entry",
              btnLabel: "Add new Entry",
            )
          : SingleChildScrollView(
              child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return LabeledBlock(
                    onClicked: (entry) =>
                        projectScreenController.pushNamedTimeEntryForm(
                      context,
                      project,
                      entry,
                    ),
                    timeEntries: data[index],
                    label: data[index].first.startTime.toMonthAndYearString(),
                  );
                },
              ),
            ),
      error: (error, stackTrace) => LoadingErrorWidget(
        onRefresh: () =>
            projectScreenState.value!.refreshIndicatorKey.currentState!.show(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
