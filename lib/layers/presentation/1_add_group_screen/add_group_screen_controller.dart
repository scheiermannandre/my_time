// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/layers/data/list_groups_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen_controller.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_group_screen_controller.g.dart';

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

@riverpod
class AddGroupScreenController extends _$AddGroupScreenController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;
  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
    // nothing to do
  }

  Future<void> onBtnTap(BuildContext context, String groupName) async {
    if (groupName.isEmpty) {
      return;
    }
    final group = GroupDTO(name: groupName);
    if (await _addGroup(group)) {
      await ref.refresh(homePageDataProvider.future);
      if (mounted) {
        goToGroupPage(context, group);
      }
    }
  }

  void goToGroupPage(BuildContext context, GroupDTO group) {
    context.pushReplacementNamed(AppRoute.group, params: {'gid': group.id});
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  Future<bool> _addGroup(GroupDTO group) async {
    state = const AsyncValue.loading();
    final value = await AsyncValue.guard(
        () => ref.read(groupsRepositoryProvider).addGroup(group));
    if (mounted) {
      state = const AsyncData(null);
    }
    return value.hasError == false;
  }
}
