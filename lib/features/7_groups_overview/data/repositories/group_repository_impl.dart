import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firestore_groups_data_source.dart';
import 'package:my_time/features/7_groups_overview/data/models/group_model.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/repositories/group_repository.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
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
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref.read(groupFirestoreDataSourceProvider).deleteGroup(uid, groupId);
  }

  /// Adds a new group with the given [name].
  @override
  Future<void> addGroup(String name) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(groupFirestoreDataSourceProvider)
        .createGroup(uid, GroupModel(name: name, projects: const []));
  }

  @override
  Future<List<GroupEntity>> fetchGroups() {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(groupFirestoreDataSourceProvider)
        .fetchGroups(uid)
        .then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Stream<List<GroupEntity>> watchGroups() {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(groupFirestoreDataSourceProvider)
        .watchGroups(uid)
        .map((event) {
      return event.map((e) => e.toEntity()).toList();
    });
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
  yield* ref.read(groupRepositoryImplProvider).watchGroups();
}

/// Riverpod provider for streaming a list of [ProjectEntity].
@riverpod
FutureOr<List<GroupEntity>> groupsFuture(GroupsFutureRef ref) {
  return ref.read(groupRepositoryImplProvider).fetchGroups();
}
