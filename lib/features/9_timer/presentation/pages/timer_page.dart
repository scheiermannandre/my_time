import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/color_tokens.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/modals/modal_bottom_sheet_ui.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/persistent_sheet_scaffold.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:my_time/features/9_timer/data/repositories/timer_data_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_state.dart';
import 'package:my_time/features/9_timer/domain/services/timer_service.dart';
import 'package:my_time/features/9_timer/presentation/state_management/timer_page_controller.dart';
import 'package:my_time/features/9_timer/presentation/widgets/time_display.dart';
import 'package:my_time/features/9_timer/presentation/widgets/timer_action_buttons.dart';
import 'package:my_time/router/app_route.dart';

/// The TimerPage lets the user start a work timer to automatically
/// track the time spent on a project.
class TimerPage extends ConsumerWidget {
  /// Creates a [TimerPage].
  const TimerPage({
    required String groupId,
    required String projectId,
    required String projectName,
    super.key,
  })  : _projectId = projectId,
        _groupId = groupId,
        _projectName = projectName;

  // ignore: unused_field
  final String _groupId;
  final String _projectId;
  final String _projectName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerPage = ref.watchAndListenStateProviderError(
      context,
      timerPageControllerProvider,
      timerPageControllerProvider.notifier,
    );

    final project = ref
        .watch(streamProjectProvider(groupId: _groupId, projectId: _projectId));
    ref.listen(streamProjectProvider(groupId: _groupId, projectId: _projectId),
        (_, next) {
      if (next is AsyncError) {
        next.showAlertDialogOnError(context);
      }
    });

    return PersistentSheetScaffold(
      appBar: AppBar(
        title: Text(project.valueOrNull?.name ?? _projectName),
      ),
      body: SpacedColumn(
        spacing: SpaceTokens.veryVeryLarge,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final timerDuration = ref.watch(timerStreamProvider(_projectId));
              return TimeDisplay(
                duration: timerDuration.valueOrNull ?? Duration.zero,
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final timerData = ref.watch(timerDataFutureProvider(_projectId));
              final timerService = ref.watch(timerServiceProvider(_projectId));

              if (timerData.hasValue && timerService.timerServiceData == null) {
                timerService.init(timerData: timerData.valueOrNull);
                if (timerData.valueOrNull?.state == TimerState.running) {
                  timerService.start();
                }
              }
              return timerData
                      .whenData(
                        (data) => TimerActionButtons(
                          initialState:
                              timerData.valueOrNull?.state ?? TimerState.off,
                          start: () {
                            final timerData = timerService.start();
                            timerPage.controller.saveTimerData(
                              _projectId,
                              timerData,
                            );
                          },
                          pause: () {
                            final timerData = timerService.pauseResumeTimer();
                            timerPage.controller.saveTimerData(
                              _projectId,
                              timerData,
                            );
                          },
                          resume: () {
                            final timerData = timerService.pauseResumeTimer();
                            timerPage.controller.saveTimerData(
                              _projectId,
                              timerData,
                            );
                          },
                          stop: () {
                            timerService.cancelTimer();
                            timerPage.controller.deleteTimerData(_projectId);
                          },
                        ),
                      )
                      .valueOrNull ??
                  const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomSheetWidgetBuilder: (context, scrollController) {
        return project
                .whenData(
                  (data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LabeledIconButtons(
                        groupId: _groupId,
                        projectId: _projectId,
                        projectName: _projectName,
                        project: project.value!,
                        quickAccess: () {
                          timerPage.controller
                              .updateQuickAccessStatus(project.value!);
                        },
                      ),
                    ],
                  ),
                )
                .valueOrNull ??
            const SizedBox.shrink();
      },
      minChildSize: .25,
      maxChildSize: .25,
    );
  }
}

class _LabeledIconButtons extends HookWidget {
  const _LabeledIconButtons({
    required this.groupId,
    required this.projectId,
    required this.projectName,
    required this.project,
    required this.quickAccess,
    // ignore: unused_element
    this.isLoading = false,
  });
  final bool isLoading;
  final String groupId;
  final String projectId;
  final String projectName;
  final ProjectEntity project;
  final VoidCallback quickAccess;

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
              onPressed: () {
                context.goNamed(
                  AppRoute.projectSettings,
                  queryParameters: {
                    'groupId': groupId,
                    'projectId': projectId,
                    'projectName': projectName,
                  },
                );
              },
              isLoading: isLoading,
              label: context.loc.timerPageProjectSettingsBtnLabel,
              child: const Icon(Icons.settings),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: quickAccess,
              isLoading: isLoading,
              label: project.isFavorite
                  ? context.loc.timerPageFavoriteOffBtnLabel
                  : context.loc.timerPageFavoriteBtnLabel,
              child: Icon(project.isFavorite ? Icons.star : Icons.star_border),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {
                context.goNamed(
                  AppRoute.addEntryWizard,
                  queryParameters: {
                    'groupId': groupId,
                    'projectId': projectId,
                    'projectName': projectName,
                  },
                );
              },
              isLoading: isLoading,
              label: context.loc.timerPageNewEntryBtnLabel,
              child: const Icon(Icons.add),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () async {
                final entryType = await _getEntryType(context);

                if (entryType == null) return;
                if (!context.mounted) return;

                context.goNamed(
                  AppRoute.addDaysOffWizard,
                  queryParameters: {
                    'groupId': groupId,
                    'projectId': projectId,
                    'entryType': entryType.index.toString(),
                  },
                );
              },
              isLoading: isLoading,
              label: context.loc.timerPageAddDaysOffBtnLabel,
              child: const Icon(Icons.playlist_add),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () {},
              isLoading: isLoading,
              label: context.loc.timerPageHistoryBtnLabel,
              child: const Icon(Icons.history),
            ),
          ],
        ),
      ),
    );
  }

  Future<EntryType?> _getEntryType(BuildContext context) async {
    final iconColor = ThemeColorBuilder(context).getGuidingIconColor();
    return ModalBottomSheetUI.showDynamic<EntryType>(
      context: context,
      widget: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: Icon(Icons.sick, color: iconColor),
                title: Text(context.loc.entryTypeLabelSickLeave),
                onTap: () {
                  Navigator.of(context).pop(EntryType.sick);
                },
              ),
              ListTile(
                leading: Icon(Icons.beach_access, color: iconColor),
                title: Text(context.loc.entryTypeLabelVacation),
                onTap: () {
                  Navigator.of(context).pop(EntryType.vacation);
                },
              ),
              ListTile(
                leading: Icon(Icons.work_off_outlined, color: iconColor),
                title: Text(context.loc.entryTypeLabelPublicHoliday),
                onTap: () {
                  Navigator.of(context).pop(EntryType.publicHoliday);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
