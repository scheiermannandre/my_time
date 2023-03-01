import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/data/projects_repository.dart';
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

  void animateHamburger() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? hamburgerClosedAnimationController.forward()
          : hamburgerClosedAnimationController.reverse();
    });
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
          // SliverAppBar(
          //   elevation: 0, //remove elevetion
          //   backgroundColor: GlobalProperties
          //       .secondaryAccentColor, // match the color of sliver grid/list
          //   leading: const SizedBox(), // // hide arrow icon
          //   leadingWidth: 0.0, // hide arrow icon
          //   expandedHeight: 200,
          //   stretch: true,
          //   flexibleSpace:

          //   FlexibleSpaceBar(
          //     collapseMode:
          //         CollapseMode.pin, // to make radius remain if scrolled
          //     title: const Text("_myTitle"),
          //     titlePadding: const EdgeInsets.all(30),
          //     //centerTitle: true,
          //     stretchModes: const [
          //       StretchMode.zoomBackground, // zoom effect
          //       StretchMode.fadeTitle, // fade effect
          //     ],
          //     background: Container(
          //       color: GlobalProperties.secondaryAccentColor,
          //       child: Stack(
          //         fit: StackFit.expand, // expand stack
          //         children: [
          //           // ColorFiltered(
          //           //   colorFilter: ColorFilter.mode(
          //           //     Colors.black.withOpacity(0.5),
          //           //     BlendMode.srcOver,
          //           //   ),
          //           //   child: Container(
          //           //     color: GlobalProperties.primaryAccentColor,

          //           //     // child: Image.network(
          //           //     //   "data:image/jpeg;base64,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",
          //           //     //   fit: BoxFit.cover,
          //           //     // ),
          //           //   ),
          //           // ),
          //           Positioned(
          //             bottom: -1,
          //             left: 0,
          //             right: 0,
          //             child: Container(
          //               height: 30,
          //               clipBehavior: Clip.antiAlias,
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: const BorderRadius.vertical(
          //                     top: Radius.circular(50),
          //                   ),
          //                   border: Border.all(
          //                     color: Colors.white,
          //                     width: 0,
          //                   )),
          //             ),
          //           ),
          //           // Positioned(
          //           //   bottom: 0, // to bottom
          //           //   right: 45, // to right 45
          //           //   child: ClipRRect(
          //           //     borderRadius: BorderRadius.circular(120),
          //           //     child: Container(
          //           //       color: Colors.blue,
          //           //       width: 60,
          //           //       height: 60,
          //           //       child: const Icon(
          //           //         Icons.store,
          //           //         size: 26,
          //           //         color: Colors.white,
          //           //       ),
          //           //     ),
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // ResponsiveSliverAlign(
          //   padding: padding,
          //   child: const Text(
          //     "Projects",
          //     style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36),
          //   ),
          // ),
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
                              child:
                                  // ExpansionTile(
                                  //   projects: projects,
                                  //   title: "Favourites",
                                  // ),

                                  CustomExpansionTile(
                                onExpansionChanged: ((value) {}),
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
                                          onTap: () => {
                                            context.pushNamed(AppRoute.project,
                                                params: {
                                                  'pid': projects[index].name,
                                                }),
                                            setState(() {
                                              expansionTile.currentState!
                                                  .collapse();
                                            }),
                                          },
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
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: CustomListTile(
                                      onTap: () => context.pushNamed(
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

// class ExpansionTile extends StatefulWidget {
//   final List<Project> projects;
//   final String title;
//   const ExpansionTile({super.key, required this.projects, required this.title});

//   @override
//   State<ExpansionTile> createState() => _ExpansionTileState();
// }

// class _ExpansionTileState extends State<ExpansionTile> {
//   late bool _isExpanded = false;
//   double turns = 0.0;

//   void _changeRotation() {
//     if (_isExpanded) {
//       turns -= 1.0 / 2.0;
//     } else {
//       turns += 1.0 / 2.0;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: GlobalProperties.shadowColor,
//             blurRadius: 1.0, // soften the shadow
//             spreadRadius: 0.0, //extend the shadow
//           )
//         ],
//         color: Colors.white,
//         border: Border.all(
//           color: GlobalProperties.shadowColor,
//           strokeAlign: StrokeAlign.outside,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(5),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//                 _changeRotation();
//               });
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 150),
//               padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
//               decoration: BoxDecoration(
//                 color: _isExpanded
//                     ? GlobalProperties.secondaryAccentColor
//                     : GlobalProperties.backgroundColor,
//                 borderRadius: BorderRadius.vertical(
//                   top: const Radius.circular(4),
//                   bottom: _isExpanded ? Radius.zero : const Radius.circular(4),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.title,
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   AnimatedRotation(
//                     turns: turns,
//                     duration: const Duration(milliseconds: 150),
//                     child: const RotatedBox(
//                       quarterTurns: 3,
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           AnimatedSize(
//             duration: const Duration(milliseconds: 150),
//             curve: Curves.fastOutSlowIn,
//             child: Container(
//               child: !_isExpanded
//                   ? null
//                   : ListView.separated(
//                       padding: EdgeInsets.zero,
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(widget.projects[index].name),
//                           onTap: () =>
//                               context.goNamed(AppRoute.project, params: {
//                             'id': widget.projects[index].name,
//                           }),
//                           contentPadding:
//                               const EdgeInsets.only(left: 12.0, right: 12.0),
//                         );
//                       },
//                       separatorBuilder: (context, index) {
//                         return Divider(
//                           color: GlobalProperties.shadowColor,
//                           height: 0,
//                           indent: 0,
//                           thickness: 1,
//                         );
//                       },
//                       itemCount: widget.projects.length),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
