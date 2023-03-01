import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/domain/custom_timer.dart';
import 'package:my_time/features/projects_groups/presentation/4_project_screen/project_history/proejct_history_list.dart';
import 'package:my_time/features/projects_groups/presentation/4_project_screen/project_timer/timer_widget.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';
import 'package:my_time/router/app_route.dart';

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
  late AnimationController sheetController;

  late CustomTimer timer;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        reverseDuration: const Duration(milliseconds: 2000),
        vsync: this);

    _pageController = PageController(initialPage: initialPage);
    sheetController = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);

    timer = CustomTimer(stateCallback: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    animationController.dispose();
    sheetController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void pop() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      appBar: CustomAppBar(
        title: widget.projectId,
        actions: [
          IconButton(
            onPressed: () async {
              bool? deletePressed = await openBottomSheet(
                  context: context,
                  bottomSheetController: sheetController,
                  title: "Delete Project ${widget.projectId}?",
                  message: "All Entries for the Project will be lost!",
                  confirmBtnText: "Confirm",
                  onCanceled: () {
                    Navigator.of(context).pop(false);
                  },
                  onConfirmed: () {
                    Navigator.of(context).pop(true);
                  });

              if (deletePressed ?? false) {
                //ToDo
                //Delete Project
                print("Deleting Project");
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => context.pushNamed(AppRoute.timeEntryForm,
                params: {'pid': widget.projectId}),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        onTap: _onItemTapped,
        startIndex: initialPage,
        backgroundColor: GlobalProperties.backgroundColor,
        selectedBackgroundColor: GlobalProperties.secondaryAccentColor,
        unSelectedBackgroundColor: GlobalProperties.backgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        iconColor: GlobalProperties.textAndIconColor,
        style: const TextStyle(color: GlobalProperties.textAndIconColor),
        items: [
          CustomNavBarItem(
            iconData: Icons.timer_sharp,
            label: "Timer",
          ),
          // CustomNavBarItem(
          //   iconData: Icons.add,
          //   label: "Add",
          // ),
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
          ProjectHistory(
            onClicked: (entry) {
              context.pushNamed(
                AppRoute.timeEntryForm,
                params: {
                  'pid': widget.projectId,
                },
                queryParams: {'tid': entry.id},
                //extra: entry,
              );
            },
          )
        ],
      ),
    );
  }
}
