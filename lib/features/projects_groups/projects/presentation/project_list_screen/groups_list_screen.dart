import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/projects/data/projects_repository.dart';
import 'package:my_time/features/projects_groups/projects/domain/project.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/add_project_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/rounded_labeled_button.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/scrollable_rounded_button_row.dart';
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

  void animateHamburger() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? hamburgerClosedAnimationController.forward()
          : hamburgerClosedAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ScreenSliverAppBar(
            title: "Project",
            leadingIconButton: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: hamburgerClosedAnimationController,
                color: GlobalProperties.textAndIconColor,
              ),
              onPressed: () {
                animateHamburger();
                showModalBottomSheet(
                  backgroundColor: GlobalProperties.primaryAccentColor,
                  transitionAnimationController: bottomSheetController,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.9,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 5,
                            width: 40,
                            decoration: BoxDecoration(
                                color: GlobalProperties.dragIndicatorColor,
                                border: Border.all(
                                  color: GlobalProperties.dragIndicatorColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                          ),
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
                      )),
                    ),
                  ),
                ).whenComplete(() => animateHamburger());
              },
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: const Text(
              "Projects",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36),
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: ScrollableRoundendButtonRow(
              children: [
                RoundedLabeldButton(
                    icon: Icons.category,
                    text: "Add Group",
                    onPressed: () => context.goNamed(AppRoute.groups)),
                RoundedLabeldButton(
                  icon: Icons.work,
                  text: "Add Project",
                  onPressed: () => context.goNamed(AppRoute.addProjectFromHome,
                      extra: InitialLocation.project.name),
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
                              child: ExpansionTile(
                                projects: projects,
                                title: "Favourites",
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
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: CustomListTile(
                                      onTap: () => context.goNamed(
                                          AppRoute.group,
                                          params: {'gid': groups[index].name}),
                                      title: groups[index].name,
                                    ));
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

class CustomListTile extends StatefulWidget {
  final String title;
  final Function? onTap;
  const CustomListTile({super.key, required this.title, this.onTap});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: GlobalProperties.shadowColor,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
          )
        ],
        color: Colors.white,
        border: Border.all(
          color: GlobalProperties.shadowColor,
          strokeAlign: StrokeAlign.outside,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
              decoration: const BoxDecoration(
                color: GlobalProperties.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4),
                  bottom: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpansionTile extends StatefulWidget {
  final List<Project> projects;
  final String title;
  const ExpansionTile({super.key, required this.projects, required this.title});

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile> {
  late bool _isExpanded = false;
  double turns = 0.0;

  void _changeRotation() {
    if (_isExpanded) {
      turns -= 1.0 / 2.0;
    } else {
      turns += 1.0 / 2.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: GlobalProperties.shadowColor,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
          )
        ],
        color: Colors.white,
        border: Border.all(
          color: GlobalProperties.shadowColor,
          strokeAlign: StrokeAlign.outside,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                _changeRotation();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? GlobalProperties.secondaryAccentColor
                    : GlobalProperties.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(4),
                  bottom: _isExpanded ? Radius.zero : const Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 150),
                    child: const RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: Container(
              child: !_isExpanded
                  ? null
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.projects[index].name),
                          onTap: () =>
                              context.goNamed(AppRoute.project, params: {
                            'id': widget.projects[index].name,
                          }),
                          contentPadding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
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
                      itemCount: widget.projects.length),
            ),
          ),
        ],
      ),
    );
  }
}
