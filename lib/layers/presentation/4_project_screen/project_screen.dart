import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/proejct_history_list.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/timer_widget.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';

class ProjectScreen extends HookConsumerWidget {
  const ProjectScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(projectScreenControllerProvider.notifier);
    final state = ref.watch(projectScreenControllerProvider);
    final project = ref.watch(projectProvider(projectId));
    final pageController = usePageController(initialPage: 0);
    final sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    ref.listen<AsyncValue>(
      projectProvider(projectId),
      (_, state) => state.showAlertDialogOnError(context),
      onError: (error, stackTrace) {},
    );
    String projectTitle =
        project.hasValue && !project.hasError && !project.isLoading
            ? project.value!.name
            : "";
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      appBar: CustomAppBar(
        title: projectTitle,
        actions: [
          project.hasValue
              ? IconButton(
                  onPressed: () => controller.markAsFavourite(project.value!),
                  icon: project.value!.isMarkedAsFavourite
                      ? const Icon(
                          Icons.star,
                          color: Colors.black,
                        )
                      : const Icon(Icons.star_border),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.star_border,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
          IconButton(
            onPressed: () => project.hasValue
                ? controller.showDeleteBottomSheet(
                    context,
                    project.value!,
                    sheetController,
                  )
                : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => project.hasValue
                ? controller.pushNamedTimeEntryForm(context, project.value!)
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        onTap: (index) => {controller.onItemTapped(pageController, index)},
        startIndex: 0,
        backgroundColor: GlobalProperties.backgroundColor,
        selectedBackgroundColor: GlobalProperties.secondaryAccentColor,
        unSelectedBackgroundColor: GlobalProperties.backgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        iconColor: GlobalProperties.textAndIconColor,
        style: const TextStyle(color: GlobalProperties.textAndIconColor),
        items: [
          CustomNavBarItem(
            iconData: Icons.timer_sharp,
            label: "Timer",
          ),
          CustomNavBarItem(
            iconData: Icons.history,
            label: "History",
          ),
        ],
      ),
      body: RefreshIndicator(
        key: ref
            .read(projectScreenControllerProvider)
            .value!
            .refreshIndicatorKey,
        onRefresh: () async {
          await AsyncValue.guard(() => ref
              .refresh(projectProvider(projectId).future)
              .timeout(const Duration(seconds: 5)));
          await AsyncValue.guard(() => ref
              .refresh(timerDataProvider(projectId).future)
              .timeout(const Duration(seconds: 5)));
          await AsyncValue.guard(() => ref
              .refresh(projectTimeEntriesProvider(projectId).future)
              .timeout(const Duration(seconds: 5)));
          return;
        },
        child: project.when(
          data: (dto) => dto != null
              ? PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {},
                  children: <Widget>[
                    ResponsiveAlign(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: TimerWidget(
                        project: project.value!,
                      ),
                    ),
                    ProjectHistory(
                      project: project.value!,
                    )
                  ],
                )
              : const Text("Data shall not be null!"),
          error: (ex, st) => LoadingErrorWidget(
            onRefresh: () =>
                state.value!.refreshIndicatorKey.currentState?.show(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
