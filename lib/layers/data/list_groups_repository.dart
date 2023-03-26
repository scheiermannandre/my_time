import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/layers/interface/data/groups_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';

class ListGroupsRepository implements GroupsRepository {
  @override
  Future<List<GroupDTO>> fetchGroups() async {
    return await Future(() => kTestGroupsMap.values.toList());
  }

  @override
  Future<bool> addGroup(GroupDTO group) async {
    kTestGroupsMap[group.id] = group;
    return Future(() => true);
  }

  @override
  Future<GroupDTO?> fetchGroup(String groupId) async {
    GroupDTO? group;
    if (kTestGroupsMap.containsKey(groupId)) {
      group = kTestGroupsMap[groupId];
    }
    return group;
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    kTestGroupsMap.remove(groupId);
    return true;
  }
}

final groupsRepositoryProvider = Provider<ListGroupsRepository>((ref) {
  return ListGroupsRepository();
});

