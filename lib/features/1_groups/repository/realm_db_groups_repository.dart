import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/interface/interface.dart';

import 'dart:async';
import 'package:realm/realm.dart';

class RealmDbGroupsRepository implements GroupsRepository {
  final Realm realm;

  RealmDbGroupsRepository(this.realm);

  @override
  Stream<GroupsScreenModel> streamGroups() =>
      realm.all<GroupRealmModel>().changes.map(_mapToGroupScreenModel);

  GroupsScreenModel _mapToGroupScreenModel(
      RealmResultsChanges<GroupRealmModel> event) {
    List<GroupModel> groups = [];
    List<ProjectModel> projects = [];

    for (final group in event.results) {
      projects.addAll(_mapFavouriteProjects(group));
      groups.add(GroupModel.factory(id: group.id, name: group.name));
    }
    final GroupsScreenModel groupScreenModel =
        GroupsScreenModel(groups: groups, projects: projects);

    return groupScreenModel;
  }

  List<ProjectModel> _mapFavouriteProjects(GroupRealmModel group) {
    final favouriteProjects =
        group.projects.where((project) => project.isMarkedAsFavourite).map(
      (project) {
        return ProjectModel.factory(name: project.name, id: project.id);
      },
    ).toList();
    return favouriteProjects;
  }

  @override
  Future<bool> addGroup(GroupModel group) async {
    await realm.writeAsync(() {
      realm.add(GroupRealmModel(group.id, name: group.name));
    });
    return Future(() => true);
  }
}

final deviceStorageGroupsRepositoryProvider =
    Provider<RealmDbGroupsRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntry.schema,
    TimeEntryRealmModel.schema,
  ]);
  return RealmDbGroupsRepository(Realm(config));
});
