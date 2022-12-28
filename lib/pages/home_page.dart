import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/global/globals.dart';
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

  Widget padding() {
    return const Padding(
      padding: EdgeInsets.only(top: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient _gradient = const LinearGradient(
        colors: [
          GlobalProperties.SecondaryColor,
          GlobalProperties.SecondaryColor
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(0, 1),
        //stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
    return Scaffold(
      //gradient: _gradient,
      backgroundColor: GlobalProperties.SecondaryColor,
      appBar: AppBar(
        backgroundColor: GlobalProperties.PrimaryColor,
        title: const Text(
          "My Projects",
          style: TextStyle(color: GlobalProperties.TextAndIconColor),
        ),
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
                backgroundColor: GlobalProperties.SecondaryColor,
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
      ),
      body: SingleChildScrollView(
        child: Align(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlobalProperties.PrimaryColor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: GlobalProperties.TextAndIconColor,
        ),
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  CustomScaffold(
      {this.body,
      this.gradient,
      this.floatingActionButton,
      this.appBar,
      this.backgroundColor}); // and maybe other Scaffold properties

  late Widget? body;
  late Color? backgroundColor;
  late AppBar? appBar;
  late Widget? floatingActionButton;
  late LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body:
          Container(decoration: BoxDecoration(gradient: gradient), child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
