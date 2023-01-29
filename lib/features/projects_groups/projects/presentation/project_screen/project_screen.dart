import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/projects/domain/custom_timer.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_screen/proejct_history_list.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_screen/time_entry_form.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_screen/timer_widget.dart';

class ProjectScreen extends StatefulWidget {
  final String projectId;
  const ProjectScreen({super.key, required this.projectId});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen>
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

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
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
      bottomNavigationBar: NavBar(
        onTap: _onItemTapped,
        startIndex: initialPage,
        backgroundColor: GlobalProperties.BackgroundColor,
        selectedBackgroundColor: GlobalProperties.SecondaryAccentColor,
        unSelectedBackgroundColor: GlobalProperties.BackgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        iconColor: GlobalProperties.TextAndIconColor,
        style: const TextStyle(color: GlobalProperties.TextAndIconColor),
        items: [
          CustomNavBarItem(
            iconData: Icons.timer_sharp,
            label: "Timer",
          ),
          CustomNavBarItem(
            iconData: Icons.add,
            label: "Add",
          ),
          CustomNavBarItem(
            iconData: Icons.history,
            label: "History",
          ),
          // CustomNavBarItem(
          //   iconData: Icons.bar_chart,
          //   label: "Statistics",
          // ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {},
        children: <Widget>[
          ResponsiveAlign(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: TimerWidget(
              controller: animationController,
              timer: timer,
            ),
          ),
          const TimeEntryForm(),
          const ProjectHistory()
        ],
      ),
    );
  }
}
