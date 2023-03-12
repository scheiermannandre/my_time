import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/features/projects_groups/domain/project.dart';
import 'package:my_time/router/app_route.dart';

class AddProjectState {
  AddProjectState({
    this.selectedGroup = selectGroupText,
    this.isExpandable = true,
    this.value = const AsyncValue.data(null),
    required this.expansionTile,
  });
  static const String selectGroupText = "Select a Group";
  final String selectedGroup;
  final bool isExpandable;
  final GlobalKey<CustomExpansionTileState> expansionTile;

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  AddProjectState copyWith({
    String? selectedGroup,
    bool? isExpandable,
    GlobalKey<CustomExpansionTileState>? expansionTile,
    AsyncValue<void>? value,
  }) {
    return AddProjectState(
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isExpandable: isExpandable ?? this.isExpandable,
      expansionTile: expansionTile ?? this.expansionTile,
      value: value ?? this.value,
    );
  }
}

class AddProjectScreenController extends StateNotifier<AddProjectState> {
  AddProjectScreenController(
      {required this.groupRepository, required String groupName})
      : super(
          AddProjectState(
              selectedGroup: groupName.isEmpty
                  ? AddProjectState.selectGroupText
                  : groupName,
              isExpandable: groupName.isEmpty ? false : true,
              expansionTile: GlobalKey<CustomExpansionTileState>()),
        );
  final GroupsRepository groupRepository;

  void onGroupDropDownListTileTap(List<Group> groups, int index) {
    _setSelectedGroup(groups[index].name);
    state.expansionTile.currentState!.collapse();
  }

  void _setSelectedGroup(String groupName) {
    state = state.copyWith(selectedGroup: groupName);
  }

  void onBtnTap(BuildContext context, String projectName) async {
    if (state.selectedGroup == AddProjectState.selectGroupText ||
        projectName.isEmpty) {
      return;
    }
    if (await _addProject(projectName)) {
      pop(context);
    }
  }

  Future<bool> _addProject(String projectName) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(
        () => groupRepository.addProject(Project(name: projectName)));
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

  Future<List<Group>> watchGroup() async {
    final groups = await groupRepository.fetchGroupsList();
    state = state.copyWith(isExpandable: groups.isNotEmpty ? true : false);
    return groups;
  }
}

final addProjectScreenControllerProvider = StateNotifierProvider.autoDispose
    .family<AddProjectScreenController, AddProjectState, String?>(
        (ref, initialGroupName) {
  final groupRepository = ref.watch(groupsRepositoryProvider);
  return AddProjectScreenController(
      groupRepository: groupRepository, groupName: initialGroupName ?? "");
});

final groupsProvider =
    FutureProvider.autoDispose.family<List<Group>, String?>((ref, groupName) {
  final controller =
      ref.watch(addProjectScreenControllerProvider(groupName).notifier);
  return controller.watchGroup();
});
