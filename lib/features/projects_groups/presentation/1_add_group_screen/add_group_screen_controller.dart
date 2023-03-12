import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/router/app_route.dart';

class AddGroupState {
  AddGroupState({this.value = const AsyncValue.data(null)});

  final AsyncValue<void> value;
  bool get isLoading => value.isLoading;

  AddGroupState copyWith({
    AsyncValue<void>? value,
  }) {
    return AddGroupState(
      value: value ?? this.value,
    );
  }
}

class AddGroupScreenController extends StateNotifier<AddGroupState> {
  AddGroupScreenController({required this.groupRepository, required})
      : super(AddGroupState());
  final GroupsRepository groupRepository;

  Future<void> onBtnTap(BuildContext context, String groupName) async {
    if (groupName.isEmpty) {
      return;
    }
    if (await _addGroup(groupName)) {
      pop(context);
    }
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<bool> _addGroup(String groupName) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(
        () => groupRepository.addGroup(Group(name: groupName)));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }
}

final addGroupScreenControllerProvider =
    StateNotifierProvider.autoDispose<AddGroupScreenController, AddGroupState>(
        (ref) {
  final groupRepository = ref.watch(groupsRepositoryProvider);
  return AddGroupScreenController(groupRepository: groupRepository);
});
