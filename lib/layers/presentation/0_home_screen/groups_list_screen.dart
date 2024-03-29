import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/global/globals.dart';
import 'home_screen_exports.dart';

class GroupsListScreen extends HookConsumerWidget {
  const GroupsListScreen({super.key});
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(groupsListScreenControllerProvider.notifier);
    final state = ref.watch(groupsListScreenControllerProvider);
    final data = ref.watch(homePageDataProvider);

    const duration = Duration(milliseconds: 600);
    const padding = EdgeInsets.fromLTRB(10, 10, 10, 10);

    final bottomSheetAnimController = useAnimationController(
      duration: duration,
    );
    final hamburgerAnimController = useAnimationController(
      duration: duration,
    );

    ref.listen<GroupsListState>(
        groupsListScreenControllerProvider.select((state) => state.value!),
        (previous, next) {
      if (next.isPlaying) {
        hamburgerAnimController.forward();
      } else {
        hamburgerAnimController.reverse();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        key: ref
            .read(groupsListScreenControllerProvider)
            .value!
            .refreshIndicatorKey,
        onRefresh: () async {
          await AsyncValue.guard(() => ref
              .refresh(homePageDataProvider.future)
              .timeout(const Duration(seconds: 20)));
          return;
        },
        child: CustomScrollView(
          slivers: [
            ScreenSliverAppBar(
              title: context.loc.groups,
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
            SliverToBoxAdapter(
              child: ResponsiveAlign(
                padding: padding,
                child: data.when(
                  error: (error, stackTrace) => LoadingErrorWidget(
                      onRefresh: () => state
                          .value!.refreshIndicatorKey.currentState
                          ?.show()),
                  loading: () => const GroupsListLoadingState(),
                  data: (dto) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ScrollableRoundendButtonRow(
                          children: [
                            RoundedLabeldButton(
                                icon: Icons.category,
                                text: context.loc.addGroup,
                                onPressed: () =>
                                    controller.pushNamedAddGroup(context)),
                            RoundedLabeldButton(
                              icon: Icons.work,
                              text: context.loc.addProject,
                              onPressed: () =>
                                  controller.pushNamedAddProject(context),
                            ),
                          ],
                        ),
                      ),
                      dto.projects.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: CustomExpansionTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: GlobalProperties.shadowColor,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                onExpansionChanged: (value) {},
                                key: ref
                                    .read(groupsListScreenControllerProvider)
                                    .value!
                                    .expansionTile,
                                title: Text(context.loc.favourites),
                                children: <Widget>[
                                  ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(dto.projects[index].name),
                                          onTap: () =>
                                              controller.onProjectTileTap(
                                                  context, dto.projects, index),
                                          contentPadding: const EdgeInsets.only(
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
                          ? NoItemsFoundWidget(
                              onBtnTap: () => !state.isLoading
                                  ? controller.pushNamedAddGroup(
                                      context,
                                    )
                                  : null,
                              title: context.loc.noGroupsFoundTitle,
                              description: context.loc.noGroupsFoundDescription,
                              btnLabel: context.loc.noGroupsFoundBtnLabel,
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dto.groups.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
    );
  }
}
