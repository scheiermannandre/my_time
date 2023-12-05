import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/0_common/project_shell_page.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

/// The shell page for the project history.
class ProjectHistoryShellPage extends ProjectShellPage {
  /// Creates a [ProjectHistoryShellPage].
  const ProjectHistoryShellPage({
    required this.projectId,
    super.key,
  }) : super();

  /// Creates a [ProjectHistoryShellPage] with a factory constructor.
  const ProjectHistoryShellPage.factory({
    required this.projectId,
    required ScrollController controller,
    super.key,
  }) : super(
          scrollController: controller,
        );

  /// The id of the project.
  final String projectId;

  @override
  IconData getIconData() => Icons.history;

  @override
  String getLabel(BuildContext context) => context.loc.historyTabLabel;

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
                            ? _onAdd(
                                controller,
                                context,
                                project.value!,
                                true,
                                entry,
                              )
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
          return LoadingErrorWidgetDeprecated(
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
    TimeEntryModel? entry,
  ) {
    return projectScreenController.pushNamedTimeEntryForm(
      context,
      project,
      isEdit: isEdit,
      entry: entry,
    );
  }

  @override
  ProjectShellPage copyWith({
    required ScrollController controller,
  }) {
    return ProjectHistoryShellPage.factory(
      projectId: projectId,
      controller: controller,
    );
  }
}
