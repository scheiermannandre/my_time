import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

/// Shell page for the group projects.
class GroupProjectsShellPage extends ShellPage {
  /// Creates a [GroupProjectsShellPage].
  const GroupProjectsShellPage({
    required this.groupId,
    super.key,
  }) : super();

  /// The id of the group.
  final String groupId;

  @override
  IconData getIconData() => Icons.line_weight_sharp;

  @override
  String getLabel(BuildContext context) => context.loc.projectsTabLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(groupProjectsShellPageControllerProvider.notifier);
    final state = ref.watch(groupProjectsShellPageControllerProvider);
    final data = ref.watch(groupProjectsProvider(groupId));
    final sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    final scrollController = useScrollController();

    return Scaffold(
      appBar: CustomAppBar(
        title: data.isLoading || data.hasError ? '' : data.value!.group.name,
        controller: scrollController,
        actions: [
          IconButton(
            onPressed: () => !data.hasError && !state.isLoading
                ? controller.showDeleteBottomSheet(
                    context,
                    sheetController,
                    data.value!,
                  )
                : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => !data.hasError && !state.isLoading
                ? controller.pushNamedAddProject(
                    context,
                    data.value!,
                  )
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: data.when(
        data: (data) => data.projects.isEmpty
            ? NoItemsFoundWidget(
                onBtnTap: () => !state.isLoading
                    ? controller.pushNamedAddProject(
                        context,
                        data,
                      )
                    : null,
                title: context.loc.noProjectsFoundTitle,
                description: context.loc.noProjectsFoundDescription,
                btnLabel: context.loc.noProjectsFoundBtnLabel,
              )
            : RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  await AsyncValue.guard(
                    () => ref
                        .refresh(groupProjectsProvider(groupId).future)
                        .timeout(const Duration(seconds: 20)),
                  );
                  return;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.projects.length,
                    itemBuilder: (context, index) {
                      return ResponsiveAlign(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: CustomListTile(
                          title: data.projects[index].name,
                          onTap: () => controller.pushNamedProject(
                            context,
                            data.projects,
                            index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        error: (ex, st) => LoadingErrorWidget(
          onRefresh: () =>
              state.value!.refreshIndicatorKey.currentState?.show(),
        ),
        loading: () => ResponsiveAlign(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: SingleChildScrollView(
            controller: scrollController,
            child: const GroupProjectsShellPageListScreenLoadingState(),
          ),
        ),
      ),
    );
  }
}
