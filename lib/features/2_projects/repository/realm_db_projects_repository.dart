import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/interface/interface.dart';

import 'dart:async';
import 'package:realm/realm.dart';

class RealmDbProjectsRepository implements ProjectsRepository {
  final Realm realm;

  RealmDbProjectsRepository(this.realm);

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
    List<GroupModel> groups = groupsFromDB
        .map((group) => GroupModel.factory(id: group.id, name: group.name))
        .toList();
    return await Future(() => groups);
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
      realm.deleteMany<ProjectRealmModel>(group.projects);
      realm.delete<GroupRealmModel>(group);
    });
    return true;
  }
}

final deviceStorageProjectsRepositoryProvider =
    Provider<RealmDbProjectsRepository>((ref) {
  final config = Configuration.local(
    [
      GroupRealmModel.schema,
      ProjectRealmModel.schema,
      TimeEntryRealmModel.schema,
    ],
  );

  final Realm realm = Realm(config);
  ref.onDispose(() => realm.close());
  return RealmDbProjectsRepository(realm);
});
