import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/layers/interface/data/groups_repository.dart';
import 'package:my_time/layers/interface/dto/group.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project.dart';
import 'package:my_time/layers/interface/dto/time_entry.dart';
import 'package:realm/realm.dart';

class ListGroupsRepository implements GroupsRepository {
  final Realm realm;

  ListGroupsRepository(this.realm);

  @override
  Future<List<GroupDTO>> fetchGroups() async {
    final groupsFromDB = realm.all<Group>();
    List<GroupDTO> groups = [];
    for (final group in groupsFromDB) {
      groups.add(GroupDTO.factory(id: group.id, name: group.name));
    }
    return await Future(() => groups);
  }

  @override
  Future<bool> addGroup(GroupDTO group) async {
    await realm.writeAsync(() {
      realm.add(Group(group.id, name: group.name));
    });
    return Future(() => true);
  }

  @override
  Future<GroupDTO?> fetchGroup(String groupId) async {
    final group = realm.all<Group>().query("id == '$groupId'").first;
    return GroupDTO.factory(id: group.id, name: group.name);
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    final group = realm.all<Group>().query("id == '$groupId'").first;
    await realm.writeAsync(() {
      realm.deleteMany<Project>(group.projects);
      realm.delete<Group>(group);
    });
    return true;
  }
}

final groupsRepositoryProvider = Provider<ListGroupsRepository>((ref) {
  final config =
      Configuration.local([Group.schema, Project.schema, TimeEntry.schema]);
  return ListGroupsRepository(Realm(config));
});
