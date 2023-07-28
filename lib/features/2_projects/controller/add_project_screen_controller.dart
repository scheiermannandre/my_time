import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/router/app_route.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_project_screen_controller.g.dart';

@riverpod
class AddProjectScreenController extends _$AddProjectScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<AddProjectState> build(String arg) {
    ref.onDispose(() => current = Object());

    return AddProjectState(
      isExpandable: arg.isEmpty ? false : true,
      expansionTile: GlobalKey<CustomExpansionTileState>(),
    );
  }

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

  void onBtnTap(BuildContext context, String projectName) async {
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
      await _refreshData(project);
      if (mounted) {
        goToProject(context, project);
      }
    }
  }

  Future<void> _refreshData(ProjectModel project) async {
    //ref.invalidate(groupsDataProvider);
    ref.invalidate(groupWithProjectsDTOProvider(project.groupId));
  }

  Future<bool> _addProject(ProjectModel project) async {
    state = AsyncData(state.value!.copyWith(value: const AsyncValue.loading()));
    final value = await AsyncValue.guard(() =>
        ref.read(deviceStorageProjectsRepositoryProvider).addProject(project));
    state = AsyncData(state.value!.copyWith(value: value));
    return value.hasError == false;
  }

  void goToProject(BuildContext context, ProjectModel project) {
    context.pushReplacementNamed(AppRoute.project, pathParameters: {
      'pid': project.id,
    });
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<List<GroupModel>> watchGroups() async {
    final groups =
        await ref.read(deviceStorageProjectsRepositoryProvider).fetchGroups();
    state = AsyncData(
        state.value!.copyWith(isExpandable: groups.isNotEmpty ? true : false));
    return groups;
  }

  Future<List<GroupModel>> watchGroupById(String groupId) async {
    final group = await ref
        .read(deviceStorageProjectsRepositoryProvider)
        .fetchGroup(groupId);
    if (group != null) {
      state = AsyncData(
        state.value!.copyWith(
            isExpandable: false,
            selectedGroup: group,
            selectedGroupName: group.name),
      );
      return [group];
    }
    return [];
  }
}

final groupsProvider = FutureProvider.autoDispose
    .family<List<GroupModel>, String?>((ref, groupId) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupId ?? "").notifier);

  if (groupId != null) {
    return controller.watchGroupById(groupId);
  } else {
    return controller.watchGroups();
  }
});

class AddProjectState {
  AddProjectState({
    this.selectedGroup,
    this.selectedGroupName,
    this.isExpandable = true,
    this.value = const AsyncValue.data(null),
    required this.expansionTile,
  });
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GroupModel? selectedGroup;

  final String? selectedGroupName;
  final bool isExpandable;
  final GlobalKey<CustomExpansionTileState> expansionTile;

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

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
