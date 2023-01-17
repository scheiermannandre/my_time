import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/logic/custom_timer.dart';
import 'package:my_time/widgets/custom_nav_bar.dart';
import 'package:my_time/widgets/slide_in_text.dart';
import 'package:my_time/widgets/timer_widget.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int initialPage = 0;
  late AnimationController animationController;
  late CustomTimer timer;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        reverseDuration: const Duration(milliseconds: 2000),
        vsync: this);
    super.initState();
    _pageController = PageController(initialPage: initialPage);
    timer = CustomTimer(stateCallback: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

//New
  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  List<Widget> _buildTmpHistoryChilds() {
    List<Widget> childs = [];

    for (int i = 0; i <= 20; i++) {
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
          TimerWidget(
            controller: animationController,
            timer: timer,
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
