import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/bottom_sheet_dialog.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/data/projects_repository.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/features/projects_groups/domain/project.dart';
import 'package:my_time/features/projects_groups/presentation/0_groups_list_screen/rounded_labeled_button.dart';
import 'package:my_time/features/projects_groups/presentation/0_groups_list_screen/scrollable_rounded_button_row.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});
  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen>
    with TickerProviderStateMixin {
  late AnimationController bottomSheetController;
  late AnimationController hamburgerClosedAnimationController;
  bool isPlaying = false;
  @override
  initState() {
    super.initState();
    bottomSheetController = BottomSheet.createAnimationController(this);
    bottomSheetController.duration = const Duration(milliseconds: 600);
    bottomSheetController.drive(CurveTween(curve: Curves.easeIn));
    hamburgerClosedAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    bottomSheetController.dispose();
    hamburgerClosedAnimationController.dispose();
    super.dispose();
  }

  void onProjectTileTap(
      BuildContext context, List<Project> projects, int index) {
    context.pushNamed(AppRoute.project, params: {
      'pid': projects[index].name,
    });
    setState(() {
      expansionTile.currentState!.collapse();
    });
  }

  void animateHamburger() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? hamburgerClosedAnimationController.forward()
          : hamburgerClosedAnimationController.reverse();
    });
  }

  void onHamburgerTab() {
    animateHamburger();
    showBottomSheetWithWidgets(
      context: context,
      bottomSheetController: bottomSheetController,
      widgets: [
        ListTile(
          trailing: const Icon(
            Icons.settings,
            color: Colors.black,
          ),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            GoRouter.of(context).go("/settings");
          },
        ),
      ],
      whenComplete: () => animateHamburger(),
    );
  }

  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      body: CustomScrollView(
        slivers: [
          ScreenSliverAppBar(
            title: "Projects",
            leadingIconButton: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: hamburgerClosedAnimationController,
                color: GlobalProperties.textAndIconColor,
              ),
              onPressed: () => onHamburgerTab(),
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: ScrollableRoundendButtonRow(
              children: [
                RoundedLabeldButton(
                    icon: Icons.category,
                    text: "Add Group",
                    onPressed: () => context.pushNamed(AppRoute.addGroup)),
                RoundedLabeldButton(
                  icon: Icons.work,
                  text: "Add Project",
                  onPressed: () => context.pushNamed(AppRoute.addProject),
                ),
              ],
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final favouriteProjectsList =
                        ref.watch(projectsListStreamProvider);
                    return AsyncValueWidget(
                      value: favouriteProjectsList,
                      data: (projects) => projects.isEmpty
                          ? Center(
                              child: Text(
                                'No projects found',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            )
                          : ResponsiveAlign(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: CustomExpansionTile(
                                onExpansionChanged: (value) {},
                                key: expansionTile,
                                title: const Text("Favourites"),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.025),
                                children: <Widget>[
                                  ListView.separated(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(projects[index].name),
                                          onTap: () => onProjectTileTap(
                                              context, projects, index),
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
                                      itemCount: projects.length),
                                ],
                              ),
                            ),
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final groupsListValue = ref.watch(groupsListStreamProvider);
                    return AsyncValueWidget(
                      value: groupsListValue,
                      data: (groups) => groups.isEmpty
                          ? Center(
                              child: Text(
                                'No projects found',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                return ResponsiveAlign(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: CustomListTile(
                                    onTap: () => context.pushNamed(
                                        AppRoute.group,
                                        params: {'gid': groups[index].name}),
                                    title: groups[index].name,
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
