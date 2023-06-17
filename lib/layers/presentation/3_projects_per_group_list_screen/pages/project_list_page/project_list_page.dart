import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';

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