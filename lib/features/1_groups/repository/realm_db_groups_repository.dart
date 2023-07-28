import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:realm/realm.dart';

class RealmDbGroupsRepository implements GroupsRepository {
  final Realm realm;

  RealmDbGroupsRepository(this.realm);

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
  Future<List<ProjectModel>> fetchFavouriteProjects() async {
    final favouriteProjectsDB =
        realm.all<ProjectRealmModel>().query("isMarkedAsFavourite == ${true}");
    final List<ProjectModel> favouriteProjects = [];
    for (var element in favouriteProjectsDB) {
      favouriteProjects.add(
        ProjectModel.factory(
          id: element.id,
          name: element.name,
        ),
      );
    }
    final result = await Future(() => favouriteProjects);
    return result;
  }

  @override
  Future<bool> addGroup(GroupModel group) async {
    await realm.writeAsync(() {
      realm.add(GroupRealmModel(group.id, name: group.name));
    });
    return Future(() => true);
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
