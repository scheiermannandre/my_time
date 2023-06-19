import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/group_analytics_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_list_page/project_list_page.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_loading_state.dart';

class ProjectsPerGroupListScreen extends HookConsumerWidget {
  final String groupId;

  const ProjectsPerGroupListScreen({
    super.key,
    required this.groupId,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: 0);

    final controller =
        ref.watch(projectsPerGroupScreenControllerProvider.notifier);
    final state = ref.watch(projectsPerGroupScreenControllerProvider);
    final data = ref.watch(groupWithProjectsDTOProvider(groupId));
    final ScrollController scrollController = useScrollController();
    final AnimationController sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );

    ref.listen<AsyncValue>(
      groupWithProjectsDTOProvider(groupId),
      (_, state) => state.showAlertDialogOnError(context),
      onError: (error, stackTrace) {},
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: NavBar(
          onTap: (index) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0);
            }
            controller.onItemTapped(pageController, index);
          },
          startIndex: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          unSelectedBackgroundColor: Theme.of(context).colorScheme.background,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          iconColor: GlobalProperties.textAndIconColor,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
          items: [
            CustomNavBarItem(
              iconData: Icons.line_weight_sharp,
              label: context.loc.projectsTabLabel,
            ),
            CustomNavBarItem(
              iconData: Icons.bar_chart_rounded,
              label: context.loc.analyticsTabLabel,
            ),
          ],
        ),
      ),
      body: data.when(
        data: (dto) => dto.projects.isEmpty
            ? NoItemsFoundWidget(
                onBtnTap: () => !state.isLoading
                    ? controller.pushNamedAddProject(
                        context,
                        dto,
                      )
                    : null,
                title: context.loc.noProjectsFoundTitle,
                description: context.loc.noProjectsFoundDescription,
                btnLabel: context.loc.noProjectsFoundBtnLabel,
              )
            : RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  await AsyncValue.guard(() => ref
                      .refresh(groupWithProjectsDTOProvider(groupId).future)
                      .timeout(const Duration(seconds: 20)));
                  return;
                },
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {},
                  children: <Widget>[
                    ProjectsListPage(
                      title: data.isLoading || data.hasError
                          ? ""
                          : data.value!.group.name,
                      icons: [
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
                      scrollController: scrollController,
                      controller: controller,
                      projects: dto.projects,
                    ),
                     GroupAnalyticsPage()
                  ],
                )),
        error: (ex, st) => LoadingErrorWidget(
          onRefresh: () =>
              state.value!.refreshIndicatorKey.currentState?.show(),
        ),
        loading: () => ResponsiveAlign(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: SingleChildScrollView(
              controller: scrollController,
              child: const ProjectsPerGroupListScreenLoadingState()),
        ),
      ),
    );
  }
}
