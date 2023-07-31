import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';

class RealmDbTimeEntryFormRepository implements TimeEntryFormRepository {
  final Realm realm;
  RealmDbTimeEntryFormRepository(this.realm);

  @override
  Future<bool> deleteEntry(TimeEntryModel entry) async {
    final entries =
        realm.all<TimeEntryRealmModel>().query("id == '${entry.id}'");
    if (entries.isEmpty) {
      throw const app_exception.CustomAppException.entryNotFound();
    }
    await realm.writeAsync(() {
      realm.delete<TimeEntryRealmModel>(entries.first);
    });
    return true;
  }

  @override
  Future<TimeEntryModel> getEntryById(String id) async {
    var entries = realm.all<TimeEntryRealmModel>().query("id == '$id'");
    if (entries.isEmpty) {
      throw const app_exception.CustomAppException.entryNotFound();
    }
    return _convertEntryFromDB(entries.first);
  }

  TimeEntryModel _convertEntryFromDB(TimeEntryRealmModel entryDB) {
    return TimeEntryModel.factory(
        id: entryDB.id,
        projectId: entryDB.projectId,
        startTime: entryDB.startTime.toLocal(),
        endTime: entryDB.endTime.toLocal(),
        totalTime: DurationExtension.parseDuration(entryDB.totalTimeStr),
        breakTime: DurationExtension.parseDuration(entryDB.breakTimeStr),
        description: entryDB.description);
  }

  @override
  Future<bool> addTimeEntry(TimeEntryModel entry) async {
    final project = realm
        .all<ProjectRealmModel>()
        .query("id == '${entry.projectId}'")
        .firstOrNull;
    if (project == null) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    realm.writeAsync(() {
      final newEntryDB = TimeEntryRealmModel(
        entry.id,
        entry.projectId,
        "",
        entry.startTime,
        entry.endTime,
        entry.totalTime.toString(),
        entry.breakTime.toString(),
        description: entry.description,
      );
      project.timeEntries.add(newEntryDB);
    });
    return await Future.value(true);
  }

  @override
  Future<bool> updateTimeEntry(TimeEntryModel entry) {
    final entryDB = realm
        .all<TimeEntryRealmModel>()
        .query("id == '${entry.id}'")
        .firstOrNull;
    if (entryDB == null) {
      throw const app_exception.CustomAppException.entryNotFound();
    }
    realm.writeAsync(() {
      entryDB.startTime = entry.startTime;
      entryDB.endTime = entry.endTime;
      entryDB.totalTimeStr = entry.totalTime.toString();
      entryDB.breakTimeStr = entry.breakTime.toString();
      entryDB.description = entry.description;
    });
    return Future.value(true);
  }

  @override
  Future<List<TimeEntryModel>> getTimeEntriesByProjectId(
      String projectId) async {
    final entries =
        realm.all<TimeEntryRealmModel>().query("projectId == '$projectId'");

    return await Future.value(
      entries.map((entry) => _convertEntryFromDB(entry)).toList(),
    );
  }
}

final timeEntryFormRepositoryProvider =
    Provider<RealmDbTimeEntryFormRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  return RealmDbTimeEntryFormRepository(Realm(config));
});
