import 'dart:async';

import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_model.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_with_settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_data_source.g.dart';

/// An abstract class representing a local data source for managing
/// groups and projects.
abstract class LocalDataSource {
  /// Observes changes to the list of groups.
  Stream<List<GroupModel>> watchGroups();

  /// Deletes a group identified by its [groupId].
  Future<void> deleteGroup(String groupId);

  /// Adds a new [group] to the local data source.
  Future<void> addGroup(GroupModel group);

  /// Adds a new [project] with settings to the local data source.
  Future<void> addProject(ProjectWithSettingsModel project);
}

/// An implementation of the [LocalDataSource] interface.
///
/// This implementation generates an initial list of groups with projects and
/// provides methods to watch, delete, add groups, and add projects.
class LocalDataSourceImpl implements LocalDataSource {
  /// Constructs a [LocalDataSourceImpl] and initializes it with sample data.
  LocalDataSourceImpl() {
    _groups = List.generate(
      3,
      (index) => GroupModel(
        name: 'Group $index',
        projects: List.generate(
          3,
          (projectIndex) => ProjectModel(
            groupId: projectIndex.toString(),
            id: projectIndex.toString(),
            name: 'Group $index Project $projectIndex',
            isFavorite: projectIndex >= 2,
          ),
        ),
      ),
    );
    _groupsController.add(_groups);
  }

  /// Internal controller for emitting updates to the list of groups.
  final _groupsController = StreamController<List<GroupModel>>();

  /// List of groups managed by the local data source.
  List<GroupModel> _groups = [];

  @override
  Stream<List<GroupModel>> watchGroups() {
    return _groupsController.stream;
  }

  /// Disposes of resources associated with this [LocalDataSourceImpl].
  void dispose() {
    _groupsController.close();
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    _groups.removeWhere((group) => group.id == groupId);
    _groupsController.add(_groups);
    return Future.value();
  }

  @override
  Future<void> addGroup(GroupModel group) async {
    _groups.add(group);
    _groupsController.add(_groups);
    return Future.value();
  }

  @override
  Future<void> addProject(ProjectWithSettingsModel project) async {
    // Simulates an asynchronous delay, e.g., a network request.
    await Future<void>.delayed(const Duration(seconds: 4));

    // Adds a new project to the first group with the matching [groupId].
    _groups.firstWhere((group) => group.id == project.groupId).projects.add(
          ProjectModel(
            id: project.id,
            name: project.name,
            groupId: project.groupId,
            isFavorite: project.isFavorite,
          ),
        );
    _groupsController.add(_groups);
    return Future.value();
  }
}

/// Riverpod provider for creating an instance of [LocalDataSourceImpl].
@riverpod
LocalDataSourceImpl groupLocalDataSource(
  GroupLocalDataSourceRef ref,
) {
  return LocalDataSourceImpl();
}
