// ignore_for_file: only_throw_errors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';
import 'package:realm/realm.dart';

/// RealmDb implementation of the [TimeEntryFormRepository].
class RealmDbTimeEntryFormRepository implements TimeEntryFormRepository {
  /// Constructor for the [RealmDbTimeEntryFormRepository].
  RealmDbTimeEntryFormRepository(this.realm);

  /// The realm instance.
  final Realm realm;

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
    final entries = realm.all<TimeEntryRealmModel>().query("id == '$id'");
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
      description: entryDB.description,
    );
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
    await realm.writeAsync(() {
      final newEntryDB = TimeEntryRealmModel(
        entry.id,
        entry.projectId,
        '',
        entry.startTime,
        entry.endTime,
        entry.totalTime.toString(),
        entry.breakTime.toString(),
        description: entry.description,
      );
      project.timeEntries.add(newEntryDB);
    });
    return Future.value(true);
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
      entryDB
        ..startTime = entry.startTime
        ..endTime = entry.endTime
        ..totalTimeStr = entry.totalTime.toString()
        ..breakTimeStr = entry.breakTime.toString()
        ..description = entry.description;
    });
    return Future.value(true);
  }

  @override
  Future<List<TimeEntryModel>> getTimeEntriesByProjectId(
    String projectId,
  ) async {
    final entries =
        realm.all<TimeEntryRealmModel>().query("projectId == '$projectId'");

    return Future.value(
      entries.map(_convertEntryFromDB).toList(),
    );
  }
}

/// Provides a [RealmDbTimeEntryFormRepository].
final timeEntryFormRepositoryProvider =
    Provider<RealmDbTimeEntryFormRepository>((ref) {
  final config = Configuration.local([
    GroupRealmModel.schema,
    ProjectRealmModel.schema,
    TimeEntryRealmModel.schema
  ]);
  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbTimeEntryFormRepository(realm);
});
