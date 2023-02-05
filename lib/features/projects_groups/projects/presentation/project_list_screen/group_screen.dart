import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/dialogs/modal_bottom_sheet.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/projects/data/projects_repository.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/add_project_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/groups_list_screen.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class GroupScreen extends StatefulWidget {
  final String groupId;
  const GroupScreen({super.key, required this.groupId});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  ScrollController scrollController = ScrollController();
  late AnimationController sheetController;
  late int initialPage = 0;
  int appBarRows = 2;

  @override
  void initState() {
    _pageController = PageController(initialPage: initialPage);
    scrollController.addListener(changeElevation);
    sheetController = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
    EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);
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
                print("Deleting Group");
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => context.goNamed(AppRoute.groupSettings, params: {
              'gid': widget.groupId,
            }),
            icon: const Icon(Icons.download_outlined),
          ),
          IconButton(
            onPressed: () => context.goNamed(AppRoute.addProjectFromGroup,
                params: {
                  'gid': widget.groupId,
                  //'initpage': InitialLocation.group.name
                },
                extra: InitialLocation.project.name),
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
                              onTap: () => context.goNamed(AppRoute.project,
                                  params: {
                                    'gid': widget.groupId,
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
