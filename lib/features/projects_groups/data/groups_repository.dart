import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/constants/test_projects.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/features/projects_groups/domain/project.dart';

class GroupsRepository {
  final List<Group> _groups = kTestGroups;
  final List<Project> _projects = kTestProjects;

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

  Future<HomePageDTO> fetchHomePageDto() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(HomePageDTO(groups: _groups, projects: _projects));
  }

  Future<HomePageDTO> getData() {
    try {
      return Future.value(
          HomePageDTO(groups: _groups, projects: kTestProjects));
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Stream<HomePageDTO> watchHomePageData() async* {
    await Future.delayed(const Duration(seconds: 2));
    try {
      yield await getData();
    } catch (ex) {
      yield* Stream.fromFuture(Future.error(Exception()));
    }
  }

  Future<bool> addGroup(Group group) async {
    await Future.delayed(const Duration(seconds: 2));
    _groups.add(group);
    return Future(() => true);
  }

  Future<bool> addProject(Project project) async {
    await Future.delayed(const Duration(seconds: 2));
    _projects.add(project);
    return Future(() => true);
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
  HomePageDTO({this.groups = const [], this.projects = const []});
}
