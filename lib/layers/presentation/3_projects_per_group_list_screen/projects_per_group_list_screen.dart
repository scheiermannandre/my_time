import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar.dart';
import 'package:my_time/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:my_time/common/widgets/no_items_found_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_loading_state.dart';
import 'package:snappy_list_view/snappy_list_view.dart';

class ProjectsPerGroupListScreen extends HookConsumerWidget {
  final String groupId;

  const ProjectsPerGroupListScreen({
    super.key,
    required this.groupId,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: 0);

    final controller =
        ref.watch(projectsPerGroupScreenControllerProvider.notifier);
    final state = ref.watch(projectsPerGroupScreenControllerProvider);
    final data = ref.watch(groupWithProjectsDTOProvider(groupId));
    final ScrollController scrollController = useScrollController();
    final AnimationController sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );

    ref.listen<AsyncValue>(
      groupWithProjectsDTOProvider(groupId),
      (_, state) => state.showAlertDialogOnError(context),
      onError: (error, stackTrace) {},
    );
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: NavBar(
          onTap: (index) {
            if (scrollController.hasClients) {
              scrollController.jumpTo(0);
            }
            controller.onItemTapped(pageController, index);
          },
          startIndex: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          unSelectedBackgroundColor: Theme.of(context).colorScheme.background,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          iconColor: GlobalProperties.textAndIconColor,
          style: const TextStyle(color: GlobalProperties.textAndIconColor),
          items: [
            CustomNavBarItem(
              iconData: Icons.line_weight_sharp,
              label: context.loc.projectsTabLabel,
            ),
            CustomNavBarItem(
              iconData: Icons.bar_chart_rounded,
              label: context.loc.analyticsTabLabel,
            ),
          ],
        ),
      ),
      body: data.when(
        data: (dto) => dto.projects.isEmpty
            ? NoItemsFoundWidget(
                onBtnTap: () => !state.isLoading
                    ? controller.pushNamedAddProject(
                        context,
                        dto,
                      )
                    : null,
                title: context.loc.noProjectsFoundTitle,
                description: context.loc.noProjectsFoundDescription,
                btnLabel: context.loc.noProjectsFoundBtnLabel,
              )
            : RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  await AsyncValue.guard(() => ref
                      .refresh(groupWithProjectsDTOProvider(groupId).future)
                      .timeout(const Duration(seconds: 20)));
                  return;
                },
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {},
                  children: <Widget>[
                    ProjectsListPage(
                      title: data.isLoading || data.hasError
                          ? ""
                          : data.value!.group.name,
                      icons: [
                        IconButton(
                          onPressed: () => !data.hasError && !state.isLoading
                              ? controller.showDeleteBottomSheet(
                                  context,
                                  sheetController,
                                  data.value!,
                                )
                              : null,
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () => !data.hasError && !state.isLoading
                              ? controller.pushNamedAddProject(
                                  context,
                                  data.value!,
                                )
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                      scrollController: scrollController,
                      controller: controller,
                      projects: dto.projects,
                    ),
                    const ProjectsAnalyticsPage()
                  ],
                )),
        error: (ex, st) => LoadingErrorWidget(
          onRefresh: () =>
              state.value!.refreshIndicatorKey.currentState?.show(),
        ),
        loading: () => ResponsiveAlign(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: SingleChildScrollView(
              controller: scrollController,
              child: const ProjectsPerGroupListScreenLoadingState()),
        ),
      ),
    );
  }
}

class ProjectsListPage extends StatelessWidget {
  const ProjectsListPage({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.projects,
    required this.title,
    required this.icons,
  });

  final ScrollController scrollController;
  final ProjectsPerGroupScreenController controller;
  final List<ProjectDTO> projects;
  final String title;
  final List<IconButton> icons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        controller: scrollController,
        actions: icons,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ResponsiveAlign(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: CustomListTile(
                title: projects[index].name,
                onTap: () =>
                    controller.pushNamedProject(context, projects, index),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProjectsAnalyticsPage extends HookConsumerWidget {
  const ProjectsAnalyticsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TabController controller = useTabController(initialLength: 4);
    return Scaffold(
      body: Container(
        color: GlobalProperties.primaryColor,
        child: SafeArea(
          child: Container(
            color: GlobalProperties.backgroundColor,
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                      tabs: const [
                        Tab(
                          text: "Day",
                        ),
                        Tab(
                          text: "Week",
                        ),
                        Tab(
                          text: "Month",
                        ),
                        Tab(
                          text: "Year",
                        ),
                      ],
                    ),
                  ),
                )
              ],
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: const <Widget>[
                  DaysTabPage(),
                  WeekTabPage(),
                  MonthTabPage(),
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

class RRectTabIndicator extends Decoration {
  final BoxPainter _painter;

  RRectTabIndicator({required Color color}) : _painter = _RRectPainter(color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _RRectPainter extends BoxPainter {
  final Paint _paint;

  _RRectPainter(Color color)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx + cfg.size!.width * 0.3 / 2,
            offset.dy + cfg.size!.height * 0.3 / 2,
            cfg.size!.width * 0.7,
            cfg.size!.height * 0.7,
          ),
          const Radius.circular(25.0),
        ),
        _paint);
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget widget;
  SectionHeaderDelegate({required this.widget, this.height = 48});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DaysTabPage extends StatefulWidget {
   DaysTabPage({super.key});
  final List<(String, String)> days = [
    ('Fr.', '16.06'),
    ('Sa.', '17.06'),
    ('So.', '18.06'),
    ('Mo.', '19.06'),
    ('Di.', '20.06'),
    ('Mi.', '21.06'),
    ('Do.', '22.06'),
    ('Fr.', '23.06'),
    ('Sa.', '24.06'),
    ('So.', '25.06'),
  ];
  @override
  State<DaysTabPage> createState() => _DaysTabPageState();
}

class _DaysTabPageState extends State<DaysTabPage>
    with TickerProviderStateMixin {
  final PageController _controller1 = PageController(initialPage: 0);
  final PageController _controller2 = PageController(initialPage: 0);
  late bool _isPage1Scrolling;
  late bool _isPage2Scrolling;

  @override
  void initState() {
    super.initState();
    _controller1.addListener(() {
      if (_isPage1Scrolling) {
      }
    });
    _controller2.addListener(() {
      if (_isPage2Scrolling) {
        _controller1.position.correctPixels(_controller2.offset *
            _controller2.viewportFraction /
            _controller2.viewportFraction);
        _controller1.position.notifyListeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          children: [
            SizedBox(
              height: 56,
              width: double.infinity,
              child: SnappyListView(
                reverse: false,
                controller: _controller1,
                itemCount: 10,
                itemSnapping: true,
                physics: const NeverScrollableScrollPhysics(),
                visualisation: ListVisualisation.enlargement(
                    horizontalMultiplier: 1.3, verticalMultiplier: 1.3),
                itemBuilder: (context, index) {
                  return TextTab(
                    onTap: () {
                      _controller1.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      _controller2.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            if (notification.direction != ScrollDirection.idle) {
              (_controller1.position as ScrollPositionWithSingleContext)
                  .goIdle();
              _isPage2Scrolling = true;
              _isPage1Scrolling = false;
            } else {
              _isPage2Scrolling = false;
            }
          }
          return false;
        },
        child: PageView(
          controller: _controller2,
          children: const [
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
            DayPage(),
          ],
        ),
      ),
    );
  }
}

class DayPage extends StatelessWidget {
  const DayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Yesterday List Tile $index'),
        );
      },
    );
  }
}

class WeekTabPage extends StatelessWidget {
  const WeekTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Text('Week Tab Content'));
  }
}
class MonthTabPage extends StatelessWidget {
  const MonthTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Text('Week Tab Content'));
  }
}
class YearTabPage extends StatelessWidget {
  const YearTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Text('Week Tab Content'));
  }
}

class TextTab extends StatelessWidget {
  const TextTab({
    super.key,
    required this.onTap,
  });
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 44, right: 44),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text("Fr.", style: TextStyle(fontSize: 10)),
            Text("16.06", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
