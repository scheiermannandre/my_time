import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/bottom_sheet_dialog.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
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
  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();
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

  void pushNamedAddGroup(BuildContext context) =>
      context.pushNamed(AppRoute.addGroup);

  void pushNamedAddProject(BuildContext context) =>
      context.pushNamed(AppRoute.addProject);

  void pushNamedGroups(BuildContext context, HomePageDTO dto, int index) {
    return context
        .pushNamed(AppRoute.group, params: {'gid': dto.groups[index].name});
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      body: CustomScrollView(
        slivers: [
          ScreenSliverAppBar(
            title: "Groups",
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
                    onPressed: () => pushNamedAddGroup(context)),
                RoundedLabeldButton(
                  icon: Icons.work,
                  text: "Add Project",
                  onPressed: () => pushNamedAddProject(context),
                ),
              ],
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: Consumer(
              builder: (context, ref, child) {
                final value = ref.watch(valueStreamProvider);
                return AsyncValueWidget(
                  value: value,
                  data: (dto) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: CustomExpansionTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GlobalProperties.shadowColor,
                              strokeAlign: StrokeAlign.outside,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          onExpansionChanged: (value) {},
                          key: expansionTile,
                          title: const Text("Favourite Projects"),
                          children: <Widget>[
                            ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(dto.projects[index].name),
                                    onTap: () => onProjectTileTap(
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
                      ),
                      dto.groups.isEmpty
                          ? Text(
                              'No groups found',
                              style: Theme.of(context).textTheme.headline4,
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
                                    onTap: () =>
                                        pushNamedGroups(context, dto, index),
                                    title: dto.groups[index].name,
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
