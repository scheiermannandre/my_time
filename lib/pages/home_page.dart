import 'package:flutter/material.dart';
import 'package:my_time/widgets/project_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects"),
        actions: [
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
            ),
            onPressed: () {
              animateHamburger();
              showModalBottomSheet(
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
                        ListTile(
                          trailing: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Settings",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () async {},
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
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProjectTile(title: "Project 1"),
              ProjectTile(title: "Project 2"), ProjectTile(title: "Project 3"),
              ProjectTile(title: "Project 4"), ProjectTile(title: "Project 5"),
              ProjectTile(title: "Project 6"), ProjectTile(title: "Project 7"),

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
        ),
      ),
    );
  }
}
