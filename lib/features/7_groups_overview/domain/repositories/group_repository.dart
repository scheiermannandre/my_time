import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';

/// Abstract class representing operations on groups and projects.
abstract class GroupRepository {
  /// Deletes a group with the specified [groupId].
  Future<void> deleteGroup(String groupId);

  /// Adds a new group with the given [name].
  Future<void> addGroup(String name);

  /// Fetches the list of groups.
  Future<List<GroupEntity>> fetchGroups();

  /// Stream to listen for changes to the list of groups.
  Stream<List<GroupEntity>> watchGroups();
}
