import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_history/proejct_history_list.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen_controller.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_timer/timer_widget.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';

class ProjectScreen extends HookConsumerWidget {
  const ProjectScreen({super.key, required this.projectId});

  final String projectId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(projectScreenControllerProvider.notifier);
    final timerData = ref.watch(timerDataProvider(projectId));
    final pageController = usePageController(initialPage: 0);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 2000),
    );
    final sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );

    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      appBar: CustomAppBar(
        title: projectId,
        actions: [
          IconButton(
            onPressed: () => controller.showDeleteBottomSheet(
              context,
              projectId,
              sheetController,
            ),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () =>
                controller.pushNamedTimeEntryForm(context, projectId),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        onTap: (index) => controller.onItemTapped(pageController, index),
        startIndex: 0,
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
          CustomNavBarItem(
            iconData: Icons.history,
            label: "History",
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {},
        children: <Widget>[
          timerData.when(
            data: (data) => ResponsiveAlign(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: TimerWidget(
                controller: animationController,
                duration: timerData.value!.duration,
                onStartTimer: () => controller.startTimer(projectId),
                onStopTimer: () => controller.stopTimer(projectId),
                onPauseResumeTimer: () =>
                    controller.pauseResumeTimer(projectId),
                timerState: timerData.value!.state,
              ),
            ),
            error: (error, stackTrace) => const Center(child: Text("ERROR")),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          ProjectHistory(
            onClicked: (entry) => controller.pushNamedTimeEntryForm(
              context,
              projectId,
              entry,
            ),
          )
        ],
      ),
    );
  }
}
