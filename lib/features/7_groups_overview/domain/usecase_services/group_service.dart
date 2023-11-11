import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/group_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_service.g.dart';

/// Service class for managing groups.
class GroupService {
  /// Constructor that takes a [ref] parameter.
  GroupService({required this.ref});

  /// Reference to Riverpod for dependency injection.
  final Ref ref;

  /// Deletes a group with the specified [groupId].
  Future<void> deleteGroup(String groupId) {
    return ref.read(groupRepositoryImplProvider).deleteGroup(groupId);
  }

  /// Adds a new group with the given [name].
  Future<void> addGroup(String name) {
    return ref.read(groupRepositoryImplProvider).addGroup(name);
  }
}

/// Riverpod provider for the [GroupService] class.
@riverpod
GroupService groupService(GroupServiceRef ref) {
  return GroupService(ref: ref);
}
