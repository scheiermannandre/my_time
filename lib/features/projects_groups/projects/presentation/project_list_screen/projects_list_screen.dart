import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/dissmissible_tile/dissmissible_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/projects/data/projects_repository.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/rounded_labeled_button.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/scrollable_rounded_button_row.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ScreenSliverAppBar(
            title: "Project",
            leadingIconButton: IconButton(
              icon: const Icon(
                Icons.menu,
                color: GlobalProperties.TextAndIconColor,
              ),
              onPressed: () {},
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: const Text(
              "Projects",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36),
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: ScrollableRoundendButtonRow(
              children: [
                RoundedLabeldButton(
                    icon: Icons.category,
                    text: "Add Group",
                    onPressed: () => context.goNamed(AppRoute.groups)),
                RoundedLabeldButton(
                    icon: Icons.work,
                    text: "Add Project",
                    onPressed: () => context.goNamed(AppRoute.addProject)),
              ],
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: Consumer(
              builder: (context, ref, child) {
                final projectsListValue = ref.watch(projectsListStreamProvider);
                return AsyncValueWidget(
                  value: projectsListValue,
                  data: (projects) => projects.isEmpty
                      ? Center(
                          child: Text(
                            'No projects found',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        )
                      : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                      return ResponsiveAlign(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5),
                        child: DismissibleTile(
                          title: projects[index].name,
                          widget: Text(
                            projects[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                          onDeleted: (title) {
                            setState(() {});
                          },
                          onTileTab: () => context.goNamed(
                              AppRoute.project,
                              params: {'id': projects[index].name}),
                        ),
                      );
                            },
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
