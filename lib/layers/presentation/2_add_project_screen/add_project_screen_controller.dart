// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_result
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_screen_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/layers/data/list_groups_repository.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/router/app_route.dart';

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

  void onGroupDropDownListTileTap(List<GroupDTO> groups, int index) {
    _setSelectedGroup(groups[index]);
    state.value!.expansionTile.currentState!.collapse();
  }

  void _setSelectedGroup(GroupDTO group) {
    state = AsyncData(state.value!
        .copyWith(selectedGroup: group, selectedGroupName: group.name));
  }

  void onBtnTap(BuildContext context, String projectName) async {
    if (state.value!.selectedGroup == null || projectName.isEmpty) {
      return;
    }
    final project = ProjectDTO(
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

  Future<void> _refreshData(ProjectDTO project) async {
    await ref.refresh(homePageDataProvider.future);
    await ref.refresh(groupWithProjectsDTOProvider(project.groupId).future);
  }

  Future<bool> _addProject(ProjectDTO project) async {
    state = AsyncData(state.value!.copyWith(value: const AsyncValue.loading()));
    final value = await AsyncValue.guard(
        () => ref.read(projectsRepositoryProvider).addProject(project));
    state = AsyncData(state.value!.copyWith(value: value));
    return value.hasError == false;
  }

  void goToProject(BuildContext context, ProjectDTO project) {
    context.pushReplacementNamed(AppRoute.project, params: {
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

  Future<List<GroupDTO>> watchGroups() async {
    final groups = await ref.read(groupsRepositoryProvider).fetchGroups();
    state = AsyncData(
        state.value!.copyWith(isExpandable: groups.isNotEmpty ? true : false));
    return groups;
  }

  Future<List<GroupDTO>> watchGroupById(String groupId) async {
    final group = await ref.read(groupsRepositoryProvider).fetchGroup(groupId);
    if (group != null) {
      state = AsyncData(state.value!.copyWith(
          isExpandable: false,
          selectedGroup: group,
          selectedGroupName: group.name));
      return [group];
    }
    return [];
  }
}

final groupsProvider =
    FutureProvider.autoDispose.family<List<GroupDTO>, String?>((ref, groupId) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupId ?? "").notifier);
  return controller.watchGroups();
});

final singleGroupProvider =
    FutureProvider.autoDispose.family<List<GroupDTO>, String>((ref, groupId) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupId).notifier);
  return controller.watchGroupById(groupId);
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
  final GroupDTO? selectedGroup;

  final String? selectedGroupName;
  final bool isExpandable;
  final GlobalKey<CustomExpansionTileState> expansionTile;

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  AddProjectState copyWith({
    GroupDTO? selectedGroup,
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
