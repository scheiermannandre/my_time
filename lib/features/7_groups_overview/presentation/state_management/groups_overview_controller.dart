import 'package:my_time/features/7_groups_overview/domain/usecase_services/group_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_overview_controller.g.dart';

@riverpod

/// Controller for managing groups overview state and actions.
class GroupsOverviewController extends _$GroupsOverviewController {
  /// Override the build method to handle the widget's build lifecycle.
  @override
  FutureOr<void> build() {}

  /// Asynchronous method to delete a group by its ID.
  ///
  /// - Parameters:
  ///   - `groupId`: The ID of the group to be deleted.
  ///
  /// This method triggers the deletion process, updating the state accordingly.
  Future<void> deleteGroup(String groupId) async {
    // Set the state to indicate loading.
    state = const AsyncLoading();

    // Use AsyncValue.guard to handle errors during the operation.
    state = await AsyncValue.guard(
      () => ref.read(groupServiceProvider).deleteGroup(groupId),
    );
  }

  /// Asynchronous method to add a new group with the given name.
  ///
  /// - Parameters:
  ///   - `name`: The name of the new group to be added.
  ///
  /// This method triggers the addition process, updating the state accordingly.
  Future<void> addGroup(String name) async {
    // Set the state to indicate loading.
    state = const AsyncLoading();

    // Use AsyncValue.guard to handle errors during the operation.
    state = await AsyncValue.guard(
      () => ref.read(groupServiceProvider).addGroup(name),
    );
  }
}
