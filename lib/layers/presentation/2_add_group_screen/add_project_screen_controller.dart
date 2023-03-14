// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/layers/data/list_groups_repository.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/router/app_route.dart';

class AddProjectState {
  AddProjectState({
    this.selectedGroup,
    this.selectedGroupName = selectGroupText,
    this.isExpandable = true,
    this.value = const AsyncValue.data(null),
    required this.expansionTile,
  });
  static const String selectGroupText = "Select a Group";
  final GroupDTO? selectedGroup;

  final String selectedGroupName;
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

class AddProjectScreenController extends StateNotifier<AddProjectState> {
  AddProjectScreenController(
      {required this.projectRepository,
      required this.groupRepository,
      required String groupId})
      : super(
          AddProjectState(
              selectedGroupName:
                  groupId.isEmpty ? AddProjectState.selectGroupText : groupId,
              isExpandable: groupId.isEmpty ? false : true,
              expansionTile: GlobalKey<CustomExpansionTileState>()),
        );

  final ListGroupsRepository groupRepository;
  final ListProjectsRepository projectRepository;

  void onGroupDropDownListTileTap(List<GroupDTO> groups, int index) {
    _setSelectedGroup(groups[index]);
    state.expansionTile.currentState!.collapse();
  }

  void _setSelectedGroup(GroupDTO group) {
    state = state.copyWith(selectedGroup: group, selectedGroupName: group.name);
  }

  void onBtnTap(BuildContext context, String projectName) async {
    if (state.selectedGroup == null || projectName.isEmpty) {
      return;
    }
    if (await _addProject(
      projectName,
      state.selectedGroup!,
    )) {
      pop(context);
    }
  }

  Future<bool> _addProject(String projectName, GroupDTO parent) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => projectRepository
        .addProject(ProjectDTO(name: projectName, parentId: parent.id)));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<List<GroupDTO>> watchGroup() async {
    final groups = await groupRepository.getGroups();
    state = state.copyWith(isExpandable: groups.isNotEmpty ? true : false);
    return groups;
  }
}

final addProjectScreenControllerProvider = StateNotifierProvider.autoDispose
    .family<AddProjectScreenController, AddProjectState, String?>(
        (ref, groupId) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  final groupsRepository = ref.watch(groupsRepositoryProvider);
  return AddProjectScreenController(
      projectRepository: projectsRepository,
      groupRepository: groupsRepository,
      groupId: groupId ?? "");
});

final groupsProvider = FutureProvider.autoDispose
    .family<List<GroupDTO>, String?>((ref, groupName) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupName).notifier);
  return controller.watchGroup();
});
