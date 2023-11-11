import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/local_data_source.dart';
import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_with_settings_model.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/repositories/group_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_repository_impl.g.dart';

/// Implementation of the [GroupRepository] interface.
class GroupRepositoryImpl extends GroupRepository {
  /// Constructor for [GroupRepositoryImpl].
  GroupRepositoryImpl({required this.ref});

  /// Reference to Riverpod.
  final Ref ref;

  /// Deletes a group with the specified [groupId].
  @override
  Future<void> deleteGroup(String groupId) {
    return ref.read(groupLocalDataSourceProvider).deleteGroup(groupId);
  }

  /// Adds a new group with the given [name].
  @override
  Future<void> addGroup(String name) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return ref
        .read(groupLocalDataSourceProvider)
        .addGroup(GroupModel(name: name, projects: const []));
  }

  /// Adds a new project with settings using the provided [project].
  @override
  Future<void> addProject(ProjectWithSettingsEntity project) async {
    return ref
        .read(groupLocalDataSourceProvider)
        .addProject(ProjectWithSettingsModel.fromEntity(project));
  }
}

/// Riverpod provider for [GroupRepositoryImpl].
@riverpod
GroupRepositoryImpl groupRepositoryImpl(GroupRepositoryImplRef ref) {
  return GroupRepositoryImpl(ref: ref);
}

/// Riverpod provider for streaming a list of [GroupEntity].
@riverpod
Stream<List<GroupEntity>> groupsStream(GroupsStreamRef ref) async* {
  yield* ref.watch(groupLocalDataSourceProvider).watchGroups().map((event) {
    return event.map((e) => e.toEntity()).toList();
  });
}
