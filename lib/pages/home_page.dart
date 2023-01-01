import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/logic/project.dart';
import 'package:my_time/widgets/custom_flexible_spacebar.dart';
import 'package:my_time/widgets/project_tile.dart';

// Hints for the SliverAppbar used in here
//https://stackoverflow.com/a/64583870

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Project> projects = [];
  late AnimationController bottomSheetController;
  late AnimationController hamburgerClosedAnimationController;
  bool isPlaying = false;
  bool showStartTime = false;
  DateTime startTime = DateTime(0);
  bool showEndTime = false;
  DateTime endTime = DateTime(0);
  static const String btnStringStart = "Start Time";
  static const String btnStringEnd = "Stop Time";
  static const String btnStringSave = "Save Time";

  String btnText = btnStringStart;
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

  Widget padding() {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
    );
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.BackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              actions: [
                IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: hamburgerClosedAnimationController,
                    color: GlobalProperties.TextAndIconColor,
                  ),
                  onPressed: () {
                    animateHamburger();
                    showModalBottomSheet(
                      backgroundColor: GlobalProperties.PrimaryAccentColor,
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
                                    color: GlobalProperties.DragIndicatorColor,
                                    border: Border.all(
                                      color:
                                          GlobalProperties.DragIndicatorColor,
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
                    ).whenComplete(
                      () => animateHamburger(),
                    );
                  },
                ),
              ],
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              // automaticallyImplyLeading: true,
              // leading: Icon(Icons.arrow_back),
              expandedHeight: 150,
              floating: false,
              pinned: true,
              flexibleSpace: CustomFlexibleSpaceBar(
                titlePaddingTween: EdgeInsetsTween(
                    begin: const EdgeInsets.only(left: 16.0, bottom: 16),
                    end: const EdgeInsets.only(left: 16.0, bottom: 16)),
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                title: const Text(
                  'Projects',
                  style: TextStyle(color: GlobalProperties.TextAndIconColor),
                ),
                //background: Placeholder(),
                // foreground: ,
              )),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildChildren(),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren() {
    //
    // SliverList with Rounded Corners on SliverAppbar
    // https://stackoverflow.com/a/63251876
    //
    //
    List<Widget> children = [];
    children.add(padding());
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Projects",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                index++;
                projects.add(Project(name: "Project" + index.toString()));
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            child: const Text(
              'New Project',
              style: TextStyle(color: GlobalProperties.TextAndIconColor),
            ),
          ),
        ],
      ),
    );
    children.addAll(_buildProjects());

    return children;
  }

  void _removeProject(String name) {
    // Project tmp = projects.firstWhere((element) => element.name == name);
    int index = projects.indexWhere((element) => element.name == name);
    projects.removeAt(index);
    // projects.remove(tmp);
    // projects.clear();
    //projects.removeWhere((element) => element.name == name);
    //setState(() {});
  }

  List<Widget> _buildProjects() {
    List<Widget> projectTiles = [];
    for (var element in projects) {
      projectTiles.add(ProjectTile2(
        remove: (name) {
          setState(() {
            _removeProject(name);
          });
        },
        title: element.name,
        padding: const EdgeInsets.only(top: 10),
      ));
    }
    return projectTiles;

    // showStartTime
    //     ? SizedBox(width: 200, child: Text("Start: $startTime"))
    //     : Container(),
    // showEndTime
    //     ? SizedBox(width: 200, child: Text("End: $endTime"))
    //     : Container(),
    // SizedBox(
    //   width: 200,
    //   child: ElevatedButton(
    //     onPressed: () {
    //       setState(
    //         () {
    //           if (!showStartTime && !showEndTime) {
    //             showStartTime = true;
    //             startTime = DateTime.now().toUtc();
    //             btnText = btnStringEnd;
    //           } else if (showStartTime && !showEndTime) {
    //             showEndTime = true;
    //             endTime = DateTime.now().toUtc();
    //             btnText = btnStringSave;
    //           } else {
    //             showStartTime = false;
    //             showEndTime = false;
    //             btnText = btnStringStart;
    //           }
    //         },
    //       );
    //     },
    //     style: ElevatedButton.styleFrom(shape: StadiumBorder()),
    //     child: Text(btnText),
    //   ),
    // )
  }
}
