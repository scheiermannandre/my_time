import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/constants/test_projects.dart';
import 'package:my_time/features/projects_groups/projects/domain/project.dart';

class FakeProjectsRepository {
  final List<Project> _projects = kTestProjects;

  List<Project> getProjectsList() {
    return _projects;
  }

  Project? getProject(String name) {
    return _projects.firstWhere((project) => project.name == name);
  }

  Future<List<Project>> fetchProjectsList() async {
    await Future.delayed(const Duration(seconds: 2));
    //throw Exception("Failed to load");
    return Future.value(_projects);
  }

  Stream<List<Project>> watchProjectsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _projects;
    //return Stream.value(_projects);
  }

  Stream<Project?> watchProject(String name) {
    return watchProjectsList().map(
        (projects) => projects.firstWhere((project) => project.name == name));
  }
}

final projectsRepositoryProvider = Provider<FakeProjectsRepository>((ref) {
  return FakeProjectsRepository();
});

final projectsListStreamProvider =
    StreamProvider.autoDispose<List<Project>>((ref) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.watchProjectsList();
});

final projectsListFutureProvider =
    FutureProvider.autoDispose<List<Project>>((ref) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.fetchProjectsList();
});

// Use .family when you need to pass an argument
final projectProvider =
    StreamProvider.autoDispose.family<Project?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.watchProject(id);
});
