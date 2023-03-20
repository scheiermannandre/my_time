import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
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
    //await Future.delayed(const Duration(seconds: 2));
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
    //await Future.delayed(const Duration(seconds: 2));
    kTestGroupsMap.remove(groupId);
    return true;
  }

  // Future<HomePageDTO> getData() {
  //   try {
  //     return Future.value(HomePageDTO(groups: _groups, projects: []));
  //     //  return Future.value(
  //     // HomePageDTO(groups: _groups, projects: kTestProjects));
  //   } catch (ex) {
  //     return Future.error(ex);
  //   }
  // }

  // Stream<HomePageDTO> watchHomePageData() async* {
  //   await Future.delayed(const Duration(seconds: 2));
  //   try {
  //     yield await getData();
  //   } catch (ex) {
  //     yield* Stream.fromFuture(Future.error(Exception()));
  //   }
  // }

  // Future<bool> addProject(ProjectDTO project) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   _projects.add(project);
  //   return Future(() => true);
  // }
}

final groupsRepositoryProvider = Provider<ListGroupsRepository>((ref) {
  return ListGroupsRepository();
});

// final groupsListStreamProvider =
//     StreamProvider.autoDispose<List<GroupDTO>>((ref) {
//   final groupsRepository = ref.watch(groupsRepositoryProvider);
//   return groupsRepository.watchGroupsList();
// });

// final valueStreamProvider = StreamProvider.autoDispose<HomePageDTO>((ref) {
//   final groupsRepository = ref.watch(groupsRepositoryProvider);
//   return groupsRepository.watchHomePageData();
// });
