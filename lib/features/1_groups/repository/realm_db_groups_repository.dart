import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/interface/interface.dart';

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';

class RealmDbGroupsRepository implements GroupsRepository {
  final Realm realm;

  RealmDbGroupsRepository(this.realm);

  @override
  Future<bool> addGroup(GroupModel group) async {
    await realm.writeAsync(() {
      realm.add(GroupRealmModel(group.id, name: group.name));
    });
    return Future(() => true);
  }

  @override
  Stream<List<GroupModel>> streamGroups() =>
      realm.all<GroupRealmModel>().changes.map(
            (event) => event.results
                .map(
                  (group) => GroupModel.factory(id: group.id, name: group.name),
                )
                .toList(),
          );

  @override
  Stream<List<ProjectModel>> streamFavouriteProjects() => realm
      .all<ProjectRealmModel>()
      .query("isMarkedAsFavourite == true")
      .changes
      .map(
        (event) => event.results
            .map(
              (project) => ProjectModel.factory(
                id: project.id,
                name: project.name,
              ),
            )
            .toList(),
      );
}

final deviceStorageGroupsRepositoryProvider =
    Provider<RealmDbGroupsRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntry.schema,
    TimeEntryRealmModel.schema,
  ]);
  final realm = Realm(config);
  ref.onDispose(() => realm.close());
  return RealmDbGroupsRepository(realm);
});
