import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/custom_list_tile.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';

class ProjectsPerGroupListScreen extends HookConsumerWidget {
  const ProjectsPerGroupListScreen({
    super.key,
    required this.groupId,
  });
  final String groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(groupsListScreenControllerProvider.notifier);
    final state = ref.watch(groupsListScreenControllerProvider);
    final data = ref.watch(dataProvider(groupId));

    final ScrollController scrollController = useScrollController();
    final AnimationController sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    useEffect(() {
      scrollController
          .addListener(() => controller.changeElevation(scrollController));
      return () => scrollController
          .removeListener(() => controller.changeElevation(scrollController));
    }, [scrollController]);

    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      appBar: CustomAppBar(
        title: data.isLoading ? "" : data.value!.group.name,
        controller: scrollController,
        actions: [
          IconButton(
            onPressed: () => data.hasValue && !state.isLoading
                ? controller.showDeleteBottomSheet(
                    context,
                    sheetController,
                    data.value!,
                  )
                : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => data.hasValue && !state.isLoading
                ? controller.pushNamedAddProject(
                    context,
                    data.value!,
                  )
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ResponsiveAlign(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: AsyncValueWidget(
            value: data,
            data: (data) => data.projects.isEmpty
                ? Center(
                    child: Text(
                      'No projects found',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          data.group.name,
                          style: const TextStyle(
                              fontSize: 28,
                              color: GlobalProperties.textAndIconColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.projects.length,
                        itemBuilder: (context, index) {
                          return CustomListTile(
                            title: data.projects[index].name,
                            onTap: () => controller.pushNamedProject(
                                context, data.projects, index),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
