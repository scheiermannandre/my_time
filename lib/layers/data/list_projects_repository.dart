import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/layers/interface/data/projects_repository.dart';
import 'package:my_time/layers/interface/dto/group.dart';
import 'package:my_time/layers/interface/dto/project.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:my_time/layers/interface/dto/time_entry.dart';
import 'package:realm/realm.dart';
import 'package:my_time/exceptions/app_exception.dart' as app_exception;

class ListProjectsRepository implements ProjectsRepository {
  final Realm realm;

  ListProjectsRepository(this.realm);

  @override
  Future<List<ProjectDTO>> fetchFavouriteProjects() async {
    final favouriteProjectsDB =
        realm.all<Project>().query("isMarkedAsFavourite == ${true}");
    final List<ProjectDTO> favouriteProjects = [];
    for (var element in favouriteProjectsDB) {
      favouriteProjects.add(ProjectDTO.factory(
          id: element.id,
          name: element.name,
          groupId: element.groupId,
          isMarkedAsFavourite: element.isMarkedAsFavourite));
    }
    final result = await Future(() => favouriteProjects);
    return result;
  }

  @override
  Future<bool> addProject(ProjectDTO project) async {
    await realm.writeAsync(() {
      final group =
          realm.all<Group>().query("id == '${project.groupId}'").first;
      group.projects.add(Project(project.id, project.groupId, project.name));
    });

    return Future(() => true);
  }

  @override
  Future<List<ProjectDTO>> fetchProjectsByGroupId(String groupId) async {
    final groups = realm.all<Group>().query("id == '$groupId'");
    if (groups.isEmpty) {
      throw const app_exception.AppException.groupNotFound();
    }
    final List<ProjectDTO> projects = [];
    for (var project in groups.first.projects) {
      projects.add(ProjectDTO.factory(
        id: project.id,
        groupId: project.groupId,
        name: project.name,
        isMarkedAsFavourite: project.isMarkedAsFavourite,
      ));
    }
    return projects;
  }

  @override
  Future<bool> deleteProject(ProjectDTO project) async {
    final projects = realm.all<Project>().query("id == '${project.id}'");
    if (projects.isEmpty) {
      throw const app_exception.AppException.projectNotFound();
    }
    final projectDB = projects.first;
    await realm.writeAsync(() {
      realm.deleteMany<TimeEntry>(projectDB.timeEntries);
      realm.delete<Project>(projectDB);
    });
    return true;
  }

  @override
  Future<void> updateIsFavouriteState(ProjectDTO project) async {
    var projects = realm.all<Project>().query("id == '${project.id}'");
    if (projects.isEmpty) {
      throw const app_exception.AppException.projectNotFound();
    }
    final projectDB = projects.first;
    await realm.writeAsync(() {
      projectDB.isMarkedAsFavourite = project.isMarkedAsFavourite;
    });
  }

  @override
  Stream<List<ProjectDTO>> watchProjectsByGroupId(String groupId) async* {
    yield await fetchProjectsByGroupId(groupId);
  }

  @override
  Future<ProjectDTO?> fetchProject(String projectId) async {
    final projects = realm.all<Project>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.AppException.projectNotFound();
    }
    final project = projects.first;
    return ProjectDTO.factory(
      id: project.id,
      groupId: project.groupId,
      name: project.name,
      isMarkedAsFavourite: project.isMarkedAsFavourite,
    );
  }
}

final projectsRepositoryProvider = Provider<ListProjectsRepository>((ref) {
  final config =
      Configuration.local([Group.schema, Project.schema, TimeEntry.schema]);
  return ListProjectsRepository(Realm(config));
});
