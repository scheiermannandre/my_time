import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/data/projects_repository.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class ProjectsPerGroupListScreen extends StatefulWidget {
  final String groupId;
  const ProjectsPerGroupListScreen({super.key, required this.groupId});

  @override
  State<ProjectsPerGroupListScreen> createState() =>
      _ProjectsPerGroupListScreenState();
}

class _ProjectsPerGroupListScreenState extends State<ProjectsPerGroupListScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late AnimationController sheetController;

  @override
  void initState() {
    scrollController.addListener(changeElevation);
    sheetController = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    sheetController.dispose();
    super.dispose();
  }

  bool projectButtonSelected = true;
  bool showElevation = false;
  void changeElevation() {
    setState(() {
      if (scrollController.offset > 0) {
        showElevation = true;
      } else {
        showElevation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      appBar: CustomAppBar(
        title: widget.groupId,
        controller: scrollController,
        actions: [
          IconButton(
            onPressed: () async {
              bool? deletePressed = await openBottomSheet(
                  context: context,
                  bottomSheetController: sheetController,
                  title: "Delete Group ${widget.groupId}?",
                  message:
                      "All Projects and Entries for the whole Group will be lost!",
                  confirmBtnText: "Confirm",
                  onCanceled: () {
                    Navigator.of(context).pop(false);
                  },
                  onConfirmed: () {
                    Navigator.of(context).pop(true);
                  });

              if (deletePressed ?? false) {
                //ToDo
                //Delete Group
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoute.addProject,
                  queryParams: {'gid': widget.groupId});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ResponsiveAlign(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SingleChildScrollView(
          controller: scrollController,
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
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: CustomListTile(
                              title: projects[index].name,
                              onTap: () =>
                                  context.pushNamed(AppRoute.project, params: {
                                //'gid': widget.groupId,
                                'pid': projects[index].name
                              }),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
