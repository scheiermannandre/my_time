// ignore_for_file: only_throw_errors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:realm/realm.dart';

/// RealmDb implementation of the [ProjectHistoryRepository].
class RealmDbProjectHistoryRepository implements ProjectHistoryRepository {
  /// Constructor for the [RealmDbProjectHistoryRepository].
  RealmDbProjectHistoryRepository(this.realm);

  /// The realm instance.
  final Realm realm;

  @override
  Future<ProjectModel?> fetchProject(String projectId) async {
    final projects = realm.all<ProjectRealmModel>().query("id == '$projectId'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final project = projects.first;
    return ProjectModel.factory(
      id: project.id,
      name: project.name,
    );
  }

  @override
  Stream<List<TimeEntryModel>> streamProjectEntries(
    String projectId,
  ) =>
      realm
          .all<TimeEntryRealmModel>()
          .query("projectId == '$projectId'")
          .changes
          .map(
            (entries) => entries.results.map(_convertEntryFromDB).toList(),
          );

  TimeEntryModel _convertEntryFromDB(TimeEntryRealmModel entryDB) {
    return TimeEntryModel.factory(
      id: entryDB.id,
      projectId: entryDB.projectId,
      startTime: entryDB.startTime.toLocal(),
      endTime: entryDB.endTime.toLocal(),
      totalTime: DurationExtension.parseDuration(entryDB.totalTimeStr),
      breakTime: DurationExtension.parseDuration(entryDB.breakTimeStr),
      description: entryDB.description,
    );
  }
}

/// Provides the [RealmDbProjectHistoryRepository].
final projectHistoryRepositoryProvider =
    Provider<RealmDbProjectHistoryRepository>((ref) {
  final config = Configuration.local(
    [ProjectRealmModel.schema, TimeEntryRealmModel.schema],
  );
  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbProjectHistoryRepository(realm);
});
