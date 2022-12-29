import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/global/globals.dart';
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
  late AnimationController controller;
  late AnimationController _animationController;
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
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 600);
    controller.drive(CurveTween(curve: Curves.easeIn));
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void animateHamburger() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Widget padding() {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
    );
  }

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
                    progress: _animationController,
                    color: GlobalProperties.TextAndIconColor,
                  ),
                  onPressed: () {
                    animateHamburger();
                    showModalBottomSheet(
                      backgroundColor: GlobalProperties.PrimaryAccentColor,
                      transitionAnimationController: controller,
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
                                    color: GlobalProperties.DragIndicatorColor,
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
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      padding(),
                      ProjectTile(title: "Project 1"),
                      padding(),

                      ProjectTile(title: "Project 2"),
                      padding(),

                      ProjectTile(title: "Project 3"),
                      padding(),

                      ProjectTile(title: "Project 4"),
                      padding(),

                      ProjectTile(title: "Project 5"),
                      padding(),

                      ProjectTile(title: "Project 6"),
                      padding(),

                      ProjectTile(title: "Project 7"),
                      padding(),
                      ProjectTile(title: "Project 7"),
                      padding(),
                      ProjectTile(title: "Project 7"),
                      padding(),
                      ProjectTile(title: "Project 7"),
                      padding(),
                      ProjectTile(title: "Project 7"),
                      padding(),
                      ProjectTile(title: "Project 7"),
                      padding(),

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
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalProperties.SecondaryAccentColor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: GlobalProperties.TextAndIconColor,
        ),
      ),
    );
  }
}
