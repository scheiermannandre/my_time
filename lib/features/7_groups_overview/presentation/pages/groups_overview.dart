import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/modals/mighty_modal_bottom_sheet.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/async_value_widget.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/mighty_app_bar.dart';
import 'package:my_time/core/widgets/mighty_circular_progress_indicator.dart';
import 'package:my_time/core/widgets/mighty_expandable_tile.dart';
import 'package:my_time/core/widgets/mighty_labeled_list.dart';
import 'package:my_time/core/widgets/mighty_loading_error_widget.dart';
import 'package:my_time/core/widgets/mighty_persistent_sheet_scaffold.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/spaced_row.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/group_repository_impl.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/state_management/groups_overview_controller.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/router/app_route.dart';

/// GroupsOverviewInheritedWidget.
class GroupsOverviewInheritedWidget extends InheritedWidget {
  /// Constructor for the GroupsOverviewInheritedWidget widget.
  const GroupsOverviewInheritedWidget({
    required this.themeController,
    required this.groups,
    required this.groupsOverviewController,
    required this.state,
    required super.child,
    super.key,
  });

  /// The theme controller.
  final MightyThemeController themeController;

  /// The groups.
  final AsyncValue<List<GroupEntity>> groups;

  /// The groups overview controller.
  final GroupsOverviewController groupsOverviewController;

  /// The state.
  final AsyncValue<void> state;

  /// Allows accesing the properties of the GroupsOverviewInheritedWidget.
  static GroupsOverviewInheritedWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsOverviewInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(GroupsOverviewInheritedWidget oldWidget) {
    return themeController != oldWidget.themeController ||
        groups != oldWidget.groups ||
        groupsOverviewController != oldWidget.groupsOverviewController ||
        state != oldWidget.state;
  }
}

/// GroupsOverview page.
class GroupsOverview extends HookConsumerWidget {
  /// Constructor for the GroupsOverview widget.
  const GroupsOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mightyTheme =
        ref.watchStateProvider<MightyThemeController, SystemThemeMode>(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final groups = ref.watchAndListenAsyncValueErrors<List<GroupEntity>>(
      context,
      groupsStreamProvider,
    );

    final page = ref.watchAndListenStateProviderError(
      context,
      groupsOverviewControllerProvider,
      groupsOverviewControllerProvider.notifier,
    );
    return GroupsOverviewInheritedWidget(
      themeController: mightyTheme.controller,
      groups: groups,
      groupsOverviewController: page.controller,
      state: page.state,
      child: MightyPersistentSheetScaffold(
        themeController: mightyTheme.controller,
        minChildSize: .1,
        maxChildSize: .9,
        appBar: MightyAppBar(
          themeMode: mightyTheme.state,
          title: context.loc.groups,
          actions: [
            IconButton(
              onPressed: () {
                ref.read(authRepositoryProvider).signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: AsyncValueWidget(
          value: groups,
          data: (groups) {
            return Column(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: SpaceTokens.medium,
                  ),
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: SpaceTokens.mediumSmall);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return MightyExpandableTile(
                      themeController: mightyTheme.controller,
                      title: groups[index].name,
                      items: groups[index].projects.map((project) {
                        return MightyExpandableTileItem(
                          title: project.name,
                          onPressed: () {},
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => MightyCircularProgressIndicator(
            themeController: mightyTheme.controller,
          ),
          error: (error, stackTrace) => MightyLoadingErrorWidget(
            onRefresh: () {
              ref.invalidate(groupsStreamProvider);
            },
            themeController: mightyTheme.controller,
          ),
        ),
        bottomSheetWidgetBuilder: groups.when(
          data: (data) => (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledIconButtons(
                  groups: groups.value!,
                ),
                const SizedBox(height: SpaceTokens.medium),
                MightyLabeledList(
                  label: context.loc.favourites,
                  emptyListLabel: context.loc.noFavouritesLabel,
                  themeController: mightyTheme.controller,
                  items: data
                      .expand((group) => group.projects)
                      .where((project) => project.isFavorite)
                      .map((project) => project.name)
                      .toList(),
                ),
              ],
            );
          },
          loading: () => null,
          error: (error, stackTrace) => null,
        ),
      ),
    );
  }
}

class _LabeledIconButtons extends HookWidget {
  const _LabeledIconButtons({
    required this.groups,
  });
  final List<GroupEntity> groups;

  @override
  Widget build(BuildContext context) {
    final hasGroups = groups.isNotEmpty;
    final themeController =
        GroupsOverviewInheritedWidget.of(context).themeController;

    final groupsOverviewController =
        GroupsOverviewInheritedWidget.of(context).groupsOverviewController;

    final state = GroupsOverviewInheritedWidget.of(context).state;
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: SpaceTokens.verySmall,
          children: [
            MightyActionButton.roundedLabeledIcon(
              themeController: themeController,
              iconData: Icons.category,
              label: context.loc.addGroup,
              onPressed: () => _onAddGroupPressed(
                context,
                groupsOverviewController,
              ),
              isLoading: state.isLoading,
            ),
            MightyActionButton.roundedLabeledIcon(
              themeController: themeController,
              iconData: Icons.work,
              label: context.loc.addProject,
              onPressed:
                  !hasGroups ? null : () => _onAddProjectPressed(context),
              isLoading: state.isLoading,
            ),
            MightyActionButton.roundedLabeledIcon(
              themeController: themeController,
              iconData: Icons.delete_outline,
              label: context.loc.deleteGroup,
              onPressed: !hasGroups
                  ? null
                  : () => _onDeleteGroupPressed(
                        context,
                        groupsOverviewController,
                        themeController,
                        animationController,
                      ),
              isLoading: state.isLoading,
            ),
            MightyActionButton.roundedLabeledIcon(
              themeController: themeController,
              iconData: Icons.insert_chart_outlined_rounded,
              label: context.loc.showStatistics,
              onPressed: !hasGroups ? null : () {},
              isLoading: state.isLoading,
            ),
            MightyActionButton.roundedLabeledIcon(
              themeController: themeController,
              iconData: Icons.settings,
              label: context.loc.openSettings,
              onPressed: () {},
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddGroupPressed(
    BuildContext context,
    GroupsOverviewController controller,
  ) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return Consumer(
          builder: (context, ref, child) {
            final theme = ref.watchStateProvider(
              context,
              mightyThemeControllerProvider,
              mightyThemeControllerProvider.notifier,
            );
            return AlertDialog(
              backgroundColor: theme.controller.mainBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SpaceTokens.mediumSmall,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SpaceTokens.medium,
              ),
              titlePadding: const EdgeInsets.all(
                SpaceTokens.medium,
              ),
              actionsPadding: const EdgeInsets.all(SpaceTokens.medium),
              actionsAlignment: MainAxisAlignment.center,
              actionsOverflowButtonSpacing: SpaceTokens.small,
              title:
                  Text(context.loc.addGroup, style: theme.controller.headline5),
              content: MightyTextFormField(
                controller: controller,
                autofocus: true,
              ),
              actions: [
                MightyActionButton.secondary(
                  themeController: theme.controller,
                  label: context.loc.deleteGroupCancelBtnLabel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                MightyActionButton.primary(
                  themeController: theme.controller,
                  label: context.loc.deleteGroupConfirmBtnLabel,
                  onPressed: () => Navigator.of(context).pop(controller.text),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;
    await controller.addGroup(result);
  }

  Future<void> _onDeleteGroupPressed(
    BuildContext context,
    GroupsOverviewController controller,
    MightyThemeController themeController,
    AnimationController animationController,
  ) async {
    final index = await _showGroupBottomSheet(
      context,
      themeController,
      animationController,
    );

    if (index == null) return;
    if (!context.mounted) return;

    final shouldDelete = await _showDeleteGroupBottomSheet(
      context,
      themeController,
      animationController,
      groups[index].name,
    );

    if (shouldDelete == null || shouldDelete == false) return;
    await controller.deleteGroup(groups[index].id);
  }

  Future<bool?> _showDeleteGroupBottomSheet(
    BuildContext context,
    MightyThemeController themeController,
    AnimationController animationController,
    String groupName,
  ) async {
    final shouldDelete = await showMightyModalBottomSheet<bool>(
      themeController: themeController,
      context: context,
      bottomSheetController: animationController,
      widget: Consumer(
        builder: (_, WidgetRef ref, __) {
          final theme = ref.watchStateProvider(
            context,
            mightyThemeControllerProvider,
            mightyThemeControllerProvider.notifier,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: SpaceTokens.small,
              children: [
                Text(
                  context.loc.deleteGroupTitle(groupName),
                  style: theme.controller.headline5,
                  textAlign: TextAlign.center,
                ),
                Text(
                  context.loc.deleteGroupMessage,
                  style: theme.controller.small,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: SpaceTokens.veryLarge,
                ),
                MightyActionButton.secondary(
                  themeController: theme.controller,
                  label: context.loc.deleteGroupCancelBtnLabel,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                MightyActionButton.primary(
                  themeController: theme.controller,
                  label: context.loc.deleteGroupConfirmBtnLabel,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                const SizedBox(
                  height: SpaceTokens.veryGigantic,
                ),
              ],
            ),
          );
        },
      ),
    );
    return shouldDelete;
  }

  Future<int?> _showGroupBottomSheet(
    BuildContext context,
    MightyThemeController themeController,
    AnimationController animationController,
  ) async {
    final clickedIndex = await showMightyModalBottomSheet<int>(
      heightFactor: .5,
      themeController: themeController,
      context: context,
      bottomSheetController: animationController,
      widget: Consumer(
        builder: (_, WidgetRef ref, __) {
          ref.watch(mightyThemeControllerProvider);
          final themeController =
              ref.watch(mightyThemeControllerProvider.notifier);
          return MightyLabeledList(
            showIcons: false,
            themeController: themeController,
            label: context.loc.pickGroup,
            items: groups.map((group) => group.name).toList(),
          );
        },
      ),
    );
    return clickedIndex;
  }

  void _onAddProjectPressed(BuildContext context) =>
      context.pushNamed(AppRoute.addProjectWizard);
}
