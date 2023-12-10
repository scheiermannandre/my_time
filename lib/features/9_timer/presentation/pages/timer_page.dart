import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/persistent_sheet_scaffold.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_display.dart';
import 'package:my_time/features/9_timer/presentation/widgets/timer_action_buttons.dart';

/// The TimerPage lets the user start a work timer to automatically
/// track the time spent on a project.
class TimerPage extends ConsumerWidget {
  /// Creates a [TimerPage].
  const TimerPage({
    required String groupId,
    required String projectId,
    super.key,
  })  : _projectId = projectId,
        _groupId = groupId;

  final String _groupId;
  final String _projectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      fetchProjectProvider(
        groupId: _groupId,
        projectId: _projectId,
      ),
    );

    return PersistentSheetScaffold(
      appBar: AppBar(
        title: Text(data.valueOrNull?.name ?? 'Timer'),
      ),
      body: const SpacedColumn(
        spacing: SpaceTokens.veryVeryLarge,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimeDisplay(
            duration: Duration.zero,
          ),
          TimerActionButtons(),
        ],
      ),
      bottomSheetWidgetBuilder: data.when(
        data: (data) => (context, scrollController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LabeledIconButtons(
                project: data,
              ),
            ],
          );
        },
        loading: () => null,
        error: (error, stackTrace) => null,
      ),
      minChildSize: .2,
      maxChildSize: .2,
    );
  }
}

class _LabeledIconButtons extends HookWidget {
  const _LabeledIconButtons({
    required this.project,
    // ignore: unused_element
    this.isLoading = false,
  });
  final ProjectEntity project;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: 'Project Settings',
              child: const Icon(Icons.settings),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: 'Mark as Favorite',
              child: const Icon(Icons.star_border),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: 'New Entry',
              child: const Icon(Icons.add),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: 'Add Days Off',
              child: const Icon(Icons.playlist_add),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: 'History',
              child: const Icon(Icons.history),
            ),
          ],
        ),
      ),
    );
  }
}
