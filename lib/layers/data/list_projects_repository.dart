import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/layers/interface/data/projects_repository.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class ListProjectsRepository implements ProjectsRepository {
  static const String favourites = "favourites";
  @override
  Future<List<ProjectDTO>> fetchFavouriteProjects() async {
    final result = await Future(() => kTestProjectsMap[favourites]!);
    return result;
  }

  @override
  Future<void> changeProjectsIsFavouriteState(ProjectDTO project) async {
    final isMarked = kTestProjectsMap[favourites]!
            .firstWhereOrNull((element) => element.id == project.id) !=
        null;

    if (project.isMarkedAsFavourite) {
      if (!isMarked) {
        kTestProjectsMap[favourites]!.add(project);
      }
    } else {
      if (isMarked) {
        kTestProjectsMap[favourites]!
            .removeWhere((element) => element.id == project.id);
      }
    }
    updateProject(project);
  }

  @override
  Future<void> updateProject(ProjectDTO project) async {
    if (!kTestProjectsMap.containsKey(project.groupId)) {
      return;
    }
    int index = kTestProjectsMap[project.groupId]!
        .indexWhere((element) => element.id == project.id);

    if (index != -1) {
      kTestProjectsMap[project.groupId]![index] = project;
    }
  }

  @override
  Future<bool> addProject(ProjectDTO project) async {
    if (kTestProjectsMap.containsKey(project.groupId)) {
      kTestProjectsMap[project.groupId]!.add(project);
    } else {
      kTestProjectsMap[project.groupId] = [project];
    }
    return Future(() => true);
  }

  @override
  Future<List<ProjectDTO>> fetchProjectsByGroupId(String groupId) async {
    if (kTestProjectsMap.containsKey(groupId)) {
      return kTestProjectsMap[groupId]!;
    } else {
      return [];
    }
  }

  @override
  Stream<List<ProjectDTO>> watchProjectsByGroupId(String groupId) async* {
    yield await fetchProjectsByGroupId(groupId);
  }

  @override
  Future<bool> deleteProjects(List<ProjectDTO> projects) async {
    if (projects.isEmpty) {
      return true;
    }
    final key = projects.first.groupId;
    if (kTestProjectsMap.containsKey(key)) {
      kTestProjectsMap.remove(key);
    }
    for (final project in projects) {
      kTestProjectsMap[favourites]!
          .removeWhere((favProject) => favProject.id == project.id);
    }
    return true;
  }

  @override
  Future<bool> deleteProject(ProjectDTO project) async {
    if (kTestProjectsMap.containsKey(project.groupId)) {
      kTestProjectsMap[project.groupId]!
          .removeWhere((element) => element.id == project.id);
    }
    kTestProjectsMap[favourites]!.remove(project);
    return true;
  }

  @override
  Future<ProjectDTO?> fetchProject(String projectId) async {
    ProjectDTO? project;

    kTestProjectsMap.forEach((key, value) {
      if (project != null) {
        return;
      }
      project = value.firstWhereOrNull((project) => project.id == projectId);
    });
    return project;
  }
}

final projectsRepositoryProvider = Provider<ListProjectsRepository>((ref) {
  return ListProjectsRepository();
});
