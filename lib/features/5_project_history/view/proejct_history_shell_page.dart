import 'package:my_time/common/common.dart';
import 'package:my_time/features/0_common/project_shell_page.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectHistoryShellPage extends ProjectShellPage {
  final String projectId;

  ProjectHistoryShellPage({
    super.key,
    required this.projectId,
    required BuildContext context,
  }) : super(
          iconData: Icons.timer_sharp,
          label: context.loc.timerTabLabel,
        );

  const ProjectHistoryShellPage.factory({
    super.key,
    required this.projectId,
    required String label,
    required IconData iconData,
    required ScrollController controller,
  }) : super(
          iconData: iconData,
          label: label,
          scrollController: controller,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider(projectId));

    final controller = ref
        .watch(projectHistoryShellPageControllerProvider(projectId).notifier);
    final state =
        ref.watch(projectHistoryShellPageControllerProvider(projectId));

    final timeEntriesList = ref.watch(projectHistoryProvider(projectId));
    return Scaffold(
      body: timeEntriesList.when(
        data: (data) => data!.isEmpty
            ? NoItemsFoundWidget(
                onBtnTap: () => !state.isLoading && project.hasValue
                    ? _onAdd(controller, context, project.value!, false, null)
                    : null,
                title: context.loc.noHistoryFoundTitle,
                description: context.loc.noHistoryFoundDescription,
                btnLabel: context.loc.noHistoryFoundBtnLabel,
              )
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(projectHistoryProvider(projectId));
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final languageCode =
                          Localizations.localeOf(context).languageCode;
                      return LabeledBlock(
                        languageCode: languageCode,
                        onClicked: (entry) => project.hasValue
                            ? _onAdd(controller, context, project.value!, true,
                                entry)
                            : null,
                        timeEntries: data[index],
                        label: data[index]
                            .first
                            .startTime
                            .toMonthAndYearString(languageCode),
                      );
                    },
                  ),
                ),
              ),
        error: (error, stackTrace) {
          return LoadingErrorWidget(
            onRefresh: () =>
                state.value!.refreshIndicatorKey.currentState!.show(),
          );
        },
        loading: () => const ProjectHistoryShellPageLoadingState(),
      ),
    );
  }

  void _onAdd(
      ProjectHistoryShellPageController projectScreenController,
      BuildContext context,
      ProjectModel project,
      bool isEdit,
      TimeEntryModel? entry) {
    return projectScreenController.pushNamedTimeEntryForm(
      context,
      project,
      isEdit,
      entry,
    );
  }

  @override
  ProjectShellPage copyWith({
    required ScrollController controller,
  }) {
    return ProjectHistoryShellPage.factory(
      projectId: projectId,
      label: label,
      iconData: iconData,
      controller: controller,
    );
  }
}
