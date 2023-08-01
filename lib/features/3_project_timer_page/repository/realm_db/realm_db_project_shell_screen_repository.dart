// ignore_for_file: only_throw_errors

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/features/3_project_timer_page/repository/project_shell_screen_repository.dart';
import 'package:realm/realm.dart';

/// RealmDb implementation of the [ProjectShellScreenRepository].
class RealmDbProjectShellScreenPageRepository
    implements ProjectShellScreenRepository {
  /// Constructor for the [RealmDbProjectShellScreenPageRepository].
  RealmDbProjectShellScreenPageRepository(this.realm);

  /// The realm instance.
  final Realm realm;

  @override
  Future<bool> deleteProject(String projectId) async {
    final projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final projectDB = projects.first;
    await realm.writeAsync(() {
      realm
        ..deleteMany<TimeEntryRealmModel>(projectDB.timeEntries)
        ..delete<ProjectRealmModel>(projectDB);
    });
    return true;
  }

  @override
  Future<void> updateIsFavouriteState(
    String projectId, {
    required bool isFavourite,
  }) async {
    final projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final projectDB = projects.first;
    await realm.writeAsync(() {
      projectDB.isMarkedAsFavourite = isFavourite;
    });
  }

  @override
  Future<ProjectModel?> fetchProject(String projectId) async {
    final projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final project = projects.first;
    return ProjectModel.factory(
      id: project.id,
      groupId: project.groupId,
      name: project.name,
      isMarkedAsFavourite: project.isMarkedAsFavourite,
    );
  }

  @override
  Stream<ProjectModel> streamProject(String projectId) => realm
      .all<ProjectRealmModel>()
      .firstWhere((project) => project.id == projectId)
      .changes
      .map(
        (projects) => ProjectModel.factory(
          id: projects.object.id,
          groupId: projects.object.groupId,
          name: projects.object.name,
          isMarkedAsFavourite: projects.object.isMarkedAsFavourite,
        ),
      );
}

/// Provides the [RealmDbProjectShellScreenPageRepository].
final projectsRepositoryProvider =
    Provider<RealmDbProjectShellScreenPageRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbProjectShellScreenPageRepository(realm);
});
