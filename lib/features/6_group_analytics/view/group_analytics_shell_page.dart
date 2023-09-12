import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/screens/shell_page.dart';
import 'package:my_time/common/widgets/tab_bar/rrect_tab_indicator.dart';
import 'package:my_time/features/6_group_analytics/view/pages/day/days_tab_page.dart';
import 'package:my_time/features/6_group_analytics/view/pages/month/months_tab_page.dart';
import 'package:my_time/features/6_group_analytics/view/pages/week/weeks_tab_page.dart';
import 'package:my_time/features/6_group_analytics/view/pages/year/years_tab_page.dart';
import 'package:my_time/global/globals.dart';

/// This is the page that shows the analytics of a group.
/// Display a shell - The Screen with a TabBar and TabBarView
/// The TabBarView contains the pages for the different time periods
/// Inside of the TimePeriodPages there is a nested TabBar
class GroupAnalyticsShellPage extends ShellPage {
  /// Creates a GroupAnalyticsShellPage.
  GroupAnalyticsShellPage({
    required this.groupId,
    required BuildContext context,
    super.key,
  }) : super(
          iconData: Icons.bar_chart_rounded,
          label: context.loc.analyticsTabLabel,
        );

  /// The id of the group.
  final String groupId;

  /// The scroll controller for the nested scroll view.
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTabController(initialLength: 4);
    return Scaffold(
      body: ColoredBox(
        color: GlobalProperties.primaryColor,
        child: SafeArea(
          child: ColoredBox(
            color: GlobalProperties.backgroundColor,
            child: NestedScrollView(
              controller: scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Makes the nested appbar flow with the outer appbar,
                //when scrolling down
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      ),
                    ],
                    snap: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    title: const Text('Project X', textScaleFactor: 1),
                    backgroundColor: GlobalProperties.primaryColor,
                    bottom: TabBar(
                      physics: const NeverScrollableScrollPhysics(),
                      indicator: RRectTabIndicator(color: Colors.white),
                      controller: controller,
                      onTap: (value) {
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      tabs: const [
                        Tab(
                          text: 'Day',
                        ),
                        Tab(
                          text: 'Week',
                        ),
                        Tab(
                          text: 'Month',
                        ),
                        Tab(
                          text: 'Year',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: const <Widget>[
                  DaysTabPage(),
                  WeeksTabPage(),
                  MonthsTabPage(),
                  YearTabPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
