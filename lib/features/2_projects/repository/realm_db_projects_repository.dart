import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;

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
  Future<List<ProjectModel>> fetchProjectsByGroupId(String groupId) async {
    final groups = realm.all<GroupRealmModel>().query("id == '$groupId'");
    if (groups.isEmpty) {
      throw const app_exception.CustomAppException.groupNotFound();
    }
    final List<ProjectModel> projects = [];
    for (var project in groups.first.projects) {
      projects.add(ProjectModel.factory(
        id: project.id,
        groupId: project.groupId,
        name: project.name,
      ));
    }
    return projects;
  }

  @override
  Stream<List<ProjectModel>> watchProjectsByGroupId(String groupId) async* {
    yield await fetchProjectsByGroupId(groupId);
  }

  @override
  Future<List<GroupModel>> fetchGroups() async {
    final groupsFromDB = realm.all<GroupRealmModel>();
    List<GroupModel> groups = [];
    for (final group in groupsFromDB) {
      groups.add(GroupModel.factory(id: group.id, name: group.name));
    }
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
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  return RealmDbProjectsRepository(Realm(config));
});
