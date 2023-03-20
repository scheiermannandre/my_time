import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_loading_state.dart';

class ProjectsPerGroupListScreen extends HookConsumerWidget {
  const ProjectsPerGroupListScreen({
    super.key,
    required this.groupId,
  });
  final String groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(projectsPerGroupScreenControllerProvider.notifier);
    final state = ref.watch(projectsPerGroupScreenControllerProvider);
    final data = ref.watch(groupWithProjectsDTOProvider(groupId));
    final ScrollController scrollController = useScrollController();
    final AnimationController sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    useEffect(() {
      scrollController
          .addListener(() => controller.changeElevation(scrollController));
      return () => scrollController
          .removeListener(() => controller.changeElevation(scrollController));
    }, [scrollController]);

    return RefreshIndicator(
      onRefresh: () async {
        return await ref.refresh(groupWithProjectsDTOProvider(groupId).future);
      },
      child: Scaffold(
        backgroundColor: GlobalProperties.backgroundColor,
        appBar: CustomAppBar(
          title: data.isLoading || data.hasError ? "" : data.value!.group.name,
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
        body: RefreshIndicator(
          key: state.value!.refreshIndicatorKey,
          onRefresh: () async {
            await AsyncValue.guard(() => ref
                .refresh(groupWithProjectsDTOProvider(groupId).future)
                .timeout(const Duration(seconds: 20)));
            return;
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: data.when(
              data: (dto) => dto.projects.isEmpty
                  ? ResponsiveAlign(
                      maxContentWidth: Breakpoint.mobile,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            //Icons.wifi_off_sharp,
                            Icons.search,
                            size: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "No Projects found",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Click on the button below to add a new Project",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () => !state.isLoading
                                  ? controller.pushNamedAddProject(
                                      context,
                                      dto,
                                    )
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                                backgroundColor:
                                    GlobalProperties.secondaryAccentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5), // <-- Radius
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Create New Project",
                                      style: TextStyle(
                                          color:
                                              GlobalProperties.textAndIconColor,
                                          fontSize: 18),
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: GlobalProperties.textAndIconColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ResponsiveAlign(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                dto.group.name,
                                style: const TextStyle(
                                    fontSize: 28,
                                    color: GlobalProperties.textAndIconColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dto.projects.length,
                              itemBuilder: (context, index) {
                                return CustomListTile(
                                  title: dto.projects[index].name,
                                  onTap: () => controller.pushNamedProject(
                                      context, dto.projects, index),
                                );
                              },
                            ),
                          ],
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
                    child: const ProjectsPerGroupListScreenLoadingState()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
