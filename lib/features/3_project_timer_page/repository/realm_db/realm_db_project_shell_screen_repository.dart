import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/features/3_project_timer_page/repository/project_shell_screen_repository.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;

import 'dart:async';
import 'package:realm/realm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RealmDbProjectShellScreenPageRepository
    implements ProjectShellScreenRepository {
  final Realm realm;

  RealmDbProjectShellScreenPageRepository(this.realm);

  @override
  Future<bool> deleteProject(String projectId) async {
    final projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final projectDB = projects.first;
    await realm.writeAsync(() {
      realm.deleteMany<TimeEntryRealmModel>(projectDB.timeEntries);
      realm.delete<ProjectRealmModel>(projectDB);
    });
    return true;
  }

  @override
  Future<void> updateIsFavouriteState(
      String projectId, bool isFavourite) async {
    var projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
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
}

final projectsRepositoryProvider =
    Provider<RealmDbProjectShellScreenPageRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  final Realm realm = Realm(config);
  ref.onDispose(() => realm.close());
  return RealmDbProjectShellScreenPageRepository(realm);
});
