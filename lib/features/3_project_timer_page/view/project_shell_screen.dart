import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// The shell screen for the project.
class ProjectShellScreen extends HookConsumerWidget {
  /// Creates a [ProjectShellScreen].
  const ProjectShellScreen({
    required this.children,
    required this.projectId,
    super.key,
  });

  /// The children of the shell screen.
  final List<ProjectShellPage> children;

  /// The id of the project.
  final String projectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenWithScrollController = <ProjectShellPage>[];
    final scrollController = useScrollController();

    for (final element in children) {
      childrenWithScrollController.add(
        element.copyWith(controller: scrollController),
      );
    }
    final project = ref.watch(projectProvider(projectId));

    final projectShellScreenController =
        ref.watch(projectShellScreenControllerProvider(projectId).notifier);
    final sheetController = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    return ShellScreenScaffold(
      appbar: CustomAppBar(
        controller: scrollController,
        title: project.hasValue && !project.hasError && !project.isLoading
            ? project.value!.name
            : '',
        actions: [
          if (project.hasValue)
            IconButton(
              onPressed: () => projectShellScreenController
                  .changeIsFavouriteState(project.value!),
              icon: project.value!.isMarkedAsFavourite
                  ? const Icon(
                      Icons.star,
                    )
                  : const Icon(Icons.star_border),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.star_border,
              ),
              onPressed: () {},
            ),
          IconButton(
            onPressed: () => project.hasValue
                ? projectShellScreenController.showDeleteBottomSheet(
                    context,
                    project.value!,
                    sheetController,
                  )
                : null,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => project.hasValue
                ? projectShellScreenController.pushNamedTimeEntryForm(
                    context: context,
                    project: project.value!,
                    isEdit: false,
                  )
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      children: childrenWithScrollController,
    );
  }
}
