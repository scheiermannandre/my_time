import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/labeled_block.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/project_history_list_loading_state.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectHistory extends HookConsumerWidget {
  final ProjectDTO project;
  final ScrollController scrollController;
  const ProjectHistory({
    super.key,
    required this.project,
    required this.scrollController,
  });

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
                      false,
                    )
                  : null,
              title: context.loc.noHistoryFoundTitle,
              description: context.loc.noHistoryFoundDescription,
              btnLabel: context.loc.noHistoryFoundBtnLabel,
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .refresh(projectTimeEntriesProvider(project.id).future);
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
                      onClicked: (entry) =>
                          projectScreenController.pushNamedTimeEntryForm(
                        context,
                        project,
                        true,
                        entry,
                      ),
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
      error: (error, stackTrace) => LoadingErrorWidget(
        onRefresh: () =>
            projectScreenState.value!.refreshIndicatorKey.currentState!.show(),
      ),
      loading: () => const ProjectHistoryListLoadingState(),
    );
  }
}
