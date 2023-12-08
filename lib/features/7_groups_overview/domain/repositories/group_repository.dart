import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

/// Abstract class representing operations on groups and projects.
abstract class GroupRepository {
  /// Deletes a group with the specified [groupId].
  Future<void> deleteGroup(String groupId);

  /// Adds a new group with the given [name].
  Future<void> addGroup(String name);

  /// Adds a project with settings specified by the [project] entity.
  Future<void> addProject(ProjectWithSettingsEntity project);

  /// Fetches the list of groups.
  Future<List<GroupEntity>> fetchGroups();

  /// Stream to listen for changes to the list of groups.
  Stream<List<GroupEntity>> watchGroups();
}
