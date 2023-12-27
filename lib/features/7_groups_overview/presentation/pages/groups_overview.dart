import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/group_repository_impl.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/state_management/groups_overview_controller.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/modals/modal_bottom_sheet_ui.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';
import 'package:my_time/foundation/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/async_value_widget.dart';
import 'package:my_time/foundation/core/widgets/expandable_tile.dart';
import 'package:my_time/foundation/core/widgets/labeled_list_tiles.dart';
import 'package:my_time/foundation/core/widgets/loading_error_widget.dart';
import 'package:my_time/foundation/core/widgets/loading_indicator.dart';
import 'package:my_time/foundation/core/widgets/persistent_sheet_scaffold.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';
import 'package:my_time/foundation/core/widgets/text_input_field.dart';
import 'package:my_time/router/app_route.dart';

/// GroupsOverviewInheritedWidget.
class GroupsOverviewInheritedWidget extends InheritedWidget {
  /// Constructor for the GroupsOverviewInheritedWidget widget.
  const GroupsOverviewInheritedWidget({
    required this.groups,
    required this.groupsOverviewController,
    required this.state,
    required super.child,
    super.key,
  });

  /// The theme controller.

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
    return groups != oldWidget.groups ||
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
      groups: groups,
      groupsOverviewController: page.controller,
      state: page.state,
      child: PersistentSheetScaffold(
        minChildSize: .2,
        maxChildSize: .9,
        appBar: AppBar(
          title: Text(context.loc.groups),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: SpaceTokens.verySmall),
              child: ActionButton.icon(
                child: const Icon(Icons.account_circle_outlined),
                onPressed: () {
                  context.pushNamed(AppRoute.profile);
                },
              ),
            ),
          ],
        ),
        body: AsyncValueWidget(
          value: groups,
          data: (groups) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: SpaceTokens.medium,
              ),
              shrinkWrap: true,
              itemCount: groups.length,
              addAutomaticKeepAlives: false,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: SpaceTokens.small);
              },
              itemBuilder: (BuildContext context, int index) {
                return ExpandableTile(
                  title: groups[index].name,
                  items: groups[index].projects.map((project) {
                    return ExpandableTileItem(
                      title: project.name,
                      onPressed: () {
                        context.goNamed(
                          AppRoute.timer,
                          queryParameters: {
                            'groupId': project.groupId,
                            'projectId': project.id,
                            'projectName': project.name,
                          },
                        );
                      },
                      trailingIcon: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.expand_more,
                          color:
                              ThemeColorBuilder(context).getGuidingIconColor(),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
          loading: LoadingIndicator.new,
          error: (error, stackTrace) => LoadingErrorWidget(
            onRefresh: () {
              ref.invalidate(groupsStreamProvider);
            },
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
                LabeledListTiles(
                  label: context.loc.favourites,
                  emptyListLabel: context.loc.noFavouritesLabel,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: () => _onAddGroupPressed(
                context,
                groupsOverviewController,
              ),
              isLoading: state.isLoading,
              label: context.loc.addGroup,
              child: const Icon(Icons.category_outlined),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed:
                  !hasGroups ? null : () => _onAddProjectPressed(context),
              isLoading: state.isLoading,
              label: context.loc.addProject,
              child: const Icon(Icons.work_outline),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: !hasGroups
                  ? null
                  : () => _onDeleteGroupPressed(
                        context,
                        groupsOverviewController,
                        animationController,
                      ),
              isLoading: state.isLoading,
              label: context.loc.deleteGroup,
              child: const Icon(Icons.delete_outline),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: !hasGroups ? null : () async {},
              isLoading: state.isLoading,
              label: context.loc.showStatistics,
              child: const Icon(Icons.insert_chart_outlined_rounded),
            ),
            ActionButton.iconWithBackgroundAndLabel(
              context: context,
              onPressed: !hasGroups ? null : () async {},
              isLoading: state.isLoading,
              label: context.loc.openSettings,
              child: const Icon(Icons.settings_outlined),
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
    final textController = TextEditingController();

    final result = await ModalDialogUI.show<String?>(
      context: context,
      title: context.loc.addGroup,
      content: TextInputField(
        controller: textController,
        autofocus: true,
      ),
      actions: [
        SpacedColumn(
          spacing: SpaceTokens.small,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActionButton.text(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                context.loc.deleteGroupCancelBtnLabel,
              ),
            ),
            ActionButton.primary(
              onPressed: () async {
                Navigator.of(context).pop(textController.text);
              },
              child: Text(
                context.loc.deleteGroupConfirmBtnLabel,
              ),
            ),
          ],
        ),
      ],
    );
    if (result == null) return;
    await controller.addGroup(result);
  }

  Future<void> _onDeleteGroupPressed(
    BuildContext context,
    GroupsOverviewController controller,
    AnimationController animationController,
  ) async {
    final index = await _showGroupBottomSheet(
      context,
      animationController,
    );

    if (index == null) return;
    if (!context.mounted) return;

    final shouldDelete = await _showDeleteGroupBottomSheet(
      context,
      animationController,
      groups[index].name,
    );

    if (shouldDelete == null || shouldDelete == false) return;
    await controller.deleteGroup(groups[index].id);
  }

  Future<bool?> _showDeleteGroupBottomSheet(
    BuildContext context,
    AnimationController animationController,
    String groupName,
  ) async {
    final shouldDelete = await ModalBottomSheetUI.showConfirmationSheet(
      context: context,
      bottomSheetController: animationController,
      title: context.loc.deleteGroupTitle(groupName),
      message: context.loc.deleteGroupMessage,
    );
    return shouldDelete;
  }

  Future<int?> _showGroupBottomSheet(
    BuildContext context,
    AnimationController animationController,
  ) async {
    final clickedIndex = await ModalBottomSheetUI.showDynamic<int>(
      context: context,
      bottomSheetController: animationController,
      widget: LabeledListTiles(
        showIcons: false,
        label: context.loc.pickGroup,
        items: groups.map((group) => group.name).toList(),
      ),
    );
    return clickedIndex;
  }

  Future<void> _onAddProjectPressed(BuildContext context) =>
      context.pushNamed(AppRoute.addProjectWizard);
}
