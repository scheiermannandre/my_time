import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/router/app_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_group_screen_controller.g.dart';

/// State of the AddGroupScreen.
class AddGroupState {
  /// Creates a [AddGroupState].
  AddGroupState({this.value = const AsyncValue.data(null)});

  /// The [AsyncValue] of the screen.
  final AsyncValue<void> value;

  /// Returns true if the [value] is loading.
  bool get isLoading => value.isLoading;

  /// Copy Method, so that the [AddGroupState] can be updated and still be
  /// immutable.
  AddGroupState copyWith({
    AsyncValue<void>? value,
  }) {
    return AddGroupState(
      value: value ?? this.value,
    );
  }
}

/// Controller for the AddGroupScreen.
@riverpod
class AddGroupScreenController extends _$AddGroupScreenController {
  /// Needed to check if mounted.
  final initial = Object();

  /// Needed to check if mounted.
  late Object current = initial;

  /// Returns true if the screen is mounted.
  bool get mounted => current == initial;
  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
    // nothing to do
  }

  /// Handles the tap on the add group button.
  Future<void> onAddGroupBtnTap(BuildContext context, String groupName) async {
    if (groupName.isEmpty) {
      return;
    }
    final group = GroupModel(name: groupName);
    if (await _addGroup(group)) {
      if (mounted) {
        _goToGroupPage(context, group);
      }
    }
  }

  void _goToGroupPage(BuildContext context, GroupModel group) {
    context.pushReplacementNamed(
      AppRoute.group,
      pathParameters: {'gid': group.id},
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

  Future<bool> _addGroup(GroupModel group) async {
    state = const AsyncValue.loading();
    final value = await AsyncValue.guard(
      () => ref.read(deviceStorageGroupsRepositoryProvider).addGroup(group),
    );
    if (mounted) {
      state = const AsyncData(null);
    }
    return value.hasError == false;
  }
}
