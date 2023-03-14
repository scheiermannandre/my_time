import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_loading_state.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/layers/presentation/0_home_screen/rounded_labeled_button.dart';
import 'package:my_time/layers/presentation/0_home_screen/scrollable_rounded_button_row.dart';
import 'package:my_time/global/globals.dart';

class GroupsListScreen extends HookConsumerWidget {
  const GroupsListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const duration = Duration(milliseconds: 600);
    const padding = EdgeInsets.fromLTRB(10, 10, 10, 10);

    final bottomSheetAnimController = useAnimationController(
      duration: duration,
    );
    final hamburgerAnimController = useAnimationController(
      duration: duration,
    );

    ref.listen<GroupsListState>(groupsListScreenControllerProvider,
        (previous, next) {
      if (next.isPlaying) {
        hamburgerAnimController.forward();
      } else {
        hamburgerAnimController.reverse();
      }
    });
    final controller = ref.watch(groupsListScreenControllerProvider.notifier);
    final state = ref.watch(groupsListScreenControllerProvider);
    final data = ref.watch(dataProvider);

    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      body: RefreshIndicator(
        key: ref.read(groupsListScreenControllerProvider).refreshIndicatorKey,
        onRefresh: () async {
          await AsyncValue.guard(() => ref
              .refresh(dataProvider.future)
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
          child: CustomScrollView(
            slivers: [
              ScreenSliverAppBar(
                title: "Groups",
                leadingIconButton: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: hamburgerAnimController,
                    color: GlobalProperties.textAndIconColor,
                  ),
                  onPressed: () => controller.onHamburgerTab(
                      context, bottomSheetAnimController),
                ),
              ),
              SliverFillRemaining(
                child: ResponsiveAlign(
                  padding: padding,
                  child: data.when(
                    error: (error, stackTrace) => LoadingErrorWidget(
                        onRefresh: () =>
                            state.refreshIndicatorKey.currentState?.show()),
                    loading: () => const GroupsListLoadingState(),
                    data: (dto) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScrollableRoundendButtonRow(
                          children: [
                            RoundedLabeldButton(
                                icon: Icons.category,
                                text: "Add Group",
                                onPressed: () =>
                                    controller.pushNamedAddGroup(context)),
                            RoundedLabeldButton(
                              icon: Icons.work,
                              text: "Add Project",
                              onPressed: () =>
                                  controller.pushNamedAddProject(context),
                            ),
                          ],
                        ),
                        dto.projects.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: CustomExpansionTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: GlobalProperties.shadowColor,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  onExpansionChanged: (value) {},
                                  key: ref
                                      .read(groupsListScreenControllerProvider)
                                      .expansionTile,
                                  title: const Text("Favourite Projects"),
                                  children: <Widget>[
                                    ListView.separated(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title:
                                                Text(dto.projects[index].name),
                                            onTap: () =>
                                                controller.onProjectTileTap(
                                                    context,
                                                    dto.projects,
                                                    index),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 12.0, right: 12.0),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            color: GlobalProperties.shadowColor,
                                            height: 0,
                                            indent: 0,
                                            thickness: 1,
                                          );
                                        },
                                        itemCount: dto.projects.length),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        dto.groups.isEmpty
                            ? Text(
                                'No groups found',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: dto.groups.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: CustomListTile(
                                      onTap: () => controller.pushNamedGroups(
                                          context, dto, index),
                                      title: dto.groups[index].name,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
