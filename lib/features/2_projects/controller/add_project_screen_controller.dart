import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_project_screen_controller.g.dart';

/// State of the AddProjectScreen.
@riverpod
class AddProjectScreenController extends _$AddProjectScreenController {
  /// Needed to check if mounted.
  final initial = Object();

  /// Needed to check if mounted.

  late Object current = initial;

  /// Needed to check if mounted.
  bool get mounted => current == initial;
  @override
  FutureOr<AddProjectState> build(String arg) {
    ref.onDispose(() => current = Object());

    return AddProjectState(
      isExpandable: arg.isNotEmpty,
      expansionTile: GlobalKey<CustomExpansionTileState>(),
    );
  }

  /// Handles the tap on the group dropdown list tile.
  void onGroupDropDownListTileTap(List<GroupModel> groups, int index) {
    _setSelectedGroup(groups[index]);
    state.value!.expansionTile.currentState!.collapse();
  }

  void _setSelectedGroup(GroupModel group) {
    state = AsyncData(
      state.value!
          .copyWith(selectedGroup: group, selectedGroupName: group.name),
    );
  }

  /// Handles the tap on the add project button.
  Future<void> onAddBtnTap(BuildContext context, String projectName) async {
    if (state.value!.selectedGroup == null || projectName.isEmpty) {
      return;
    }
    final project = ProjectModel(
      name: projectName,
      groupId: state.value!.selectedGroup!.id,
    );
    if (await _addProject(
      project,
    )) {
      if (mounted) {
        _goToProject(context, project);
      }
    }
  }

  Future<bool> _addProject(ProjectModel project) async {
    state = AsyncData(state.value!.copyWith(value: const AsyncValue.loading()));
    final value = await AsyncValue.guard(
      () =>
          ref.read(deviceStorageProjectsRepositoryProvider).addProject(project),
    );
    state = AsyncData(state.value!.copyWith(value: value));
    return value.hasError == false;
  }

  void _goToProject(BuildContext context, ProjectModel project) {
    context.pushReplacementNamed(
      AppRoute.project,
      pathParameters: {
        'pid': project.id,
      },
    );
  }

  /// Handles the tap on the back button.
  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  /// Used for fetching all groups.
  Future<List<GroupModel>> watchGroups() async {
    final groups =
        await ref.read(deviceStorageProjectsRepositoryProvider).fetchGroups();
    state = AsyncData(
      state.value!.copyWith(isExpandable: groups.isNotEmpty),
    );
    return groups;
  }

  /// Used for fetching a group by id.
  Future<List<GroupModel>> watchGroupById(String groupId) async {
    final group = await ref
        .read(deviceStorageProjectsRepositoryProvider)
        .fetchGroup(groupId);
    if (group != null) {
      state = AsyncData(
        state.value!.copyWith(
          isExpandable: false,
          selectedGroup: group,
          selectedGroupName: group.name,
        ),
      );
      return [group];
    }
    return [];
  }
}

/// Provides the groups.
final groupsProvider = FutureProvider.autoDispose
    .family<List<GroupModel>, String?>((ref, groupId) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupId ?? '').notifier);

  if (groupId != null) {
    return controller.watchGroupById(groupId);
  } else {
    return controller.watchGroups();
  }
});

/// State of the AddProjectScreen.
class AddProjectState {
  /// Creates a [AddProjectState].
  AddProjectState({
    required this.expansionTile,
    this.selectedGroup,
    this.selectedGroupName,
    this.isExpandable = true,
    this.value = const AsyncValue.data(null),
  });

  /// The GlobalKey of the [RefreshIndicator].
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  /// The selected group.
  final GroupModel? selectedGroup;

  /// The name of the selected group.
  final String? selectedGroupName;

  /// Indicates if the dropdown list tile is expandable.
  final bool isExpandable;

  /// The GlobalKey of the [CustomExpansionTile].
  final GlobalKey<CustomExpansionTileState> expansionTile;

  /// The [AsyncValue] of the screen.
  final AsyncValue<void> value;

  /// Returns true if the [value] is loading.
  bool get isLoading => value.isLoading;

  /// Copy Method, so that the [AddProjectState] can be updated and still be
  AddProjectState copyWith({
    GroupModel? selectedGroup,
    String? selectedGroupName,
    bool? isExpandable,
    GlobalKey<CustomExpansionTileState>? expansionTile,
    AsyncValue<void>? value,
  }) {
    return AddProjectState(
      selectedGroup: selectedGroup ?? this.selectedGroup,
      selectedGroupName: selectedGroupName ?? this.selectedGroupName,
      isExpandable: isExpandable ?? this.isExpandable,
      expansionTile: expansionTile ?? this.expansionTile,
      value: value ?? this.value,
    );
  }
}
