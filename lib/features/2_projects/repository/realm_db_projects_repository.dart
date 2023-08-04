import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:realm/realm.dart';

/// RealmDb implementation of the [ProjectsRepository].
class RealmDbProjectsRepository implements ProjectsRepository {
  /// Creates a [RealmDbProjectsRepository].
  RealmDbProjectsRepository(this.realm);

  /// The realm instance used to access the database.
  final Realm realm;

  @override
  Future<bool> addProject(ProjectModel project) async {
    await realm.writeAsync(() {
      final group = realm
          .all<GroupRealmModel>()
          .query("id == '${project.groupId}'")
          .first;
      group.projects
          .add(ProjectRealmModel(project.id, project.groupId, project.name));
    });

    return Future(() => true);
  }

  @override
  Stream<List<ProjectModel>> streamProjectsByGroupId(String groupId) =>
      realm.all<ProjectRealmModel>().query("groupId == '$groupId'").changes.map(
            (event) => event.results
                .map(
                  (project) => ProjectModel.factory(
                    id: project.id,
                    groupId: project.groupId,
                    name: project.name,
                  ),
                )
                .toList(),
          );

  @override
  Future<List<GroupModel>> fetchGroups() async {
    final groupsFromDB = realm.all<GroupRealmModel>();
    final groups = groupsFromDB
        .map((group) => GroupModel.factory(id: group.id, name: group.name))
        .toList();
    return Future(() => groups);
  }

  @override
  Future<GroupModel?> fetchGroup(String groupId) async {
    final groups = realm.all<GroupRealmModel>().query("id == '$groupId'");
    if (groups.isEmpty) {
      throw const CustomAppException.groupNotFound();
    }
    final group = groups.first;
    return GroupModel.factory(id: group.id, name: group.name);
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    final groups = realm.all<GroupRealmModel>().query("id == '$groupId'");
    if (groups.isEmpty) {
      throw const CustomAppException.groupNotFound();
    }
    final group = groups.first;
    await realm.writeAsync(() {
      realm
        ..deleteMany<ProjectRealmModel>(group.projects)
        ..delete<GroupRealmModel>(group);
    });
    return true;
  }
}

/// Provides a [RealmDbProjectsRepository].
final deviceStorageProjectsRepositoryProvider =
    Provider<RealmDbProjectsRepository>((ref) {
  final config = Configuration.local(
    [
      GroupRealmModel.schema,
      ProjectRealmModel.schema,
      TimeEntryRealmModel.schema,
    ],
  );

  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbProjectsRepository(realm);
});
