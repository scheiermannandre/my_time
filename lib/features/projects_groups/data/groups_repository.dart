import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/constants/test_projects.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/features/projects_groups/domain/project.dart';

class GroupsRepository {
  final List<Group> _groups = kTestGroups;

  List<Group> getProjectsList() {
    return _groups;
  }

  Group? getGroup(String name) {
    return _groups.firstWhere((project) => project.name == name);
  }

  Future<List<Group>> fetchGroupsList() async {
    await Future.delayed(const Duration(seconds: 2));
    //throw Exception("Failed to load");
    return Future.value(_groups);
  }

  Stream<List<Group>> watchGroupsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _groups;
    //return Stream.value(_groups);
  }

  Stream<Group?> watchGroup(String name) {
    return watchGroupsList()
        .map((groups) => groups.firstWhere((project) => project.name == name));
  }

  Stream<HomePageDTO> watchHomePageData() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield HomePageDTO(kTestGroups, kTestProjects);
    //return Stream.value(_groups);
  }
}

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepository();
});

final groupsListStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final groupsRepository = ref.watch(groupsRepositoryProvider);
  return groupsRepository.watchGroupsList();
});

final groupsListFutureProvider = FutureProvider.autoDispose<List<Group>>((ref) {
  final groupsRepository = ref.watch(groupsRepositoryProvider);
  return groupsRepository.fetchGroupsList();
});

// Use .family when you need to pass an argument
final projectProvider =
    StreamProvider.autoDispose.family<Group?, String>((ref, id) {
  final groupsRepository = ref.watch(groupsRepositoryProvider);
  return groupsRepository.watchGroup(id);
});

final valueStreamProvider = StreamProvider.autoDispose<HomePageDTO>((ref) {
  final groupsRepository = ref.watch(groupsRepositoryProvider);
  return groupsRepository.watchHomePageData();
});

class HomePageDTO {
  final List<Group> groups;
  final List<Project> projects;

  HomePageDTO(this.groups, this.projects);
}
