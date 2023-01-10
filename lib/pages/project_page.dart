import 'dart:async';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/widgets/custom_nav_bar.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late PageController _pageController;
  late int initialPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool showStartTime = false;
  DateTime startTime = DateTime(0);
  bool showEndTime = false;
  DateTime endTime = DateTime(0);
  static const String btnStringStart = "Start Time";
  static const String btnStringEnd = "Stop Time";
  static const String btnStringSave = "Save Time";
  final Stopwatch stopwatch = Stopwatch();

  String btnText = btnStringStart;
  Timer? timer;
  Duration duration = Duration(seconds: 0);

  bool timerIsActive = false;
  final int secondsPerDay = 86400;

  void startTimer() {
    timerIsActive = true;
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    if (duration.inSeconds >= secondsPerDay - 1) {
      stopTimer();
      timerIsActive = false;
    } else {
      int seconds = duration.inSeconds + 1;
      setState(() {
        duration = Duration(seconds: seconds);
      });
    }
  }

  void stopTimer({bool resets = true}) {
    setState(() {
      btnText = btnStringStart;
      timerIsActive = false;
      timer?.cancel();
      duration = Duration(seconds: 0);
    });
  }

  Widget _buildTimeDisplay() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours.remainder(24));
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
      alignment: Alignment.center,
      height: 250,
      decoration: const BoxDecoration(
          color: GlobalProperties.SecondaryAccentColor, shape: BoxShape.circle),
      child: Container(
        alignment: Alignment.center,
        height: 245,
        decoration: const BoxDecoration(
            color: GlobalProperties.BackgroundColor, shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hours,
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.w500),
                ),
                Text(
                  ":",
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.w500),
                ),
                Text(
                  minutes,
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              seconds,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Color(0xff855827)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (!timerIsActive) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12.5),
          backgroundColor: GlobalProperties.SecondaryAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- Radius
          ),
        ),
        onPressed: () {
          setState(
            () {
              if (!timerIsActive) {
                btnText = btnStringEnd;
                startTimer();
              }
            },
          );
        },
        child: const Text(
          "Start",
          style:
              TextStyle(fontSize: 16, color: GlobalProperties.TextAndIconColor),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12.5),
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Pause",
              style: TextStyle(
                  fontSize: 16, color: GlobalProperties.TextAndIconColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12.5),
              backgroundColor: GlobalProperties.SecondaryAccentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // <-- Radius
              ),
            ),
            onPressed: () {
              stopTimer();
            },
            child: const Text(
              "Finish",
              style: TextStyle(
                  fontSize: 16, color: GlobalProperties.TextAndIconColor),
            ),
          )
        ],
      );
    }
  }

//New
  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  List<Widget> _buildTmpHistoryChilds() {
    List<Widget> childs = [];

    for (int i = 0; i <= 100; i++) {
      childs.add(ListTile(
        title: Text("Tile$i"),
      ));
    }
    return childs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalProperties.BackgroundColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalProperties.TextAndIconColor,
          ),
          onPressed: (() {
            Navigator.of(context).pop();
          }),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        onTap: _onItemTapped,
        startIndex: initialPage,
        backgroundColor: GlobalProperties.BackgroundColor,
        selectedBackgroundColor: GlobalProperties.SecondaryAccentColor,
        unSelectedBackgroundColor: GlobalProperties.BackgroundColor,
        mainAxisAlignment: MainAxisAlignment.end,
        iconColor: GlobalProperties.TextAndIconColor,
        style: TextStyle(color: GlobalProperties.TextAndIconColor),
        items: [
          CustomNavBarItem(
            iconData: Icons.timer_sharp,
            label: "Timer",
          ),
          CustomNavBarItem(
            iconData: Icons.history,
            label: "History",
          ),
          CustomNavBarItem(
            iconData: Icons.bar_chart,
            label: "Statistics",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {},
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buildTimeDisplay(), _buildButtons()],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(children: _buildTmpHistoryChilds()),
          ),
          Column(
            children: <Widget>[
              ShowUp(
                child: Text("The first texto to be shown"),
                delay: 500,
              ),
              ShowUp(
                child: Text("The text below the first"),
                delay: 500 + 200,
              ),
              ShowUp(
                child: Column(
                  children: <Widget>[
                    Text("Texts together 1"),
                    Text("Texts together 2"),
                    Text("Texts together 3"),
                  ],
                ),
                delay: 500 + 400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
