import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

class RealmDbTimeEntryFormRepository implements TimeEntryFormRepository {
  final Realm realm;
  RealmDbTimeEntryFormRepository(this.realm);

  Future<bool> _addTimeEntry(
      ProjectRealmModel project, TimeEntryModel entry) async {
    if (_checkSameDateEntries(entry, project.timeEntries)) {
      throw const app_exception.CustomAppException.timeRangesOverlap();
    }
    await realm.writeAsync(() {
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
    return true;
  }

  Future<bool> _updateTimeEntry(
      TimeEntryRealmModel entry, TimeEntryModel updatedEntry) async {
    await realm.writeAsync(() {
      entry.startTime = updatedEntry.startTime;
      entry.endTime = updatedEntry.endTime;
      entry.totalTimeStr = updatedEntry.totalTime.toString();
      entry.breakTimeStr = updatedEntry.breakTime.toString();
      entry.description = updatedEntry.description;
    });
    return true;
  }

  @override
  Future<bool> saveTimeEntry(TimeEntryModel entry) async {
    final projects =
        realm.all<ProjectRealmModel>().query("id == '${entry.projectId}'");
    if (projects.isEmpty) {
      throw const app_exception.CustomAppException.projectNotFound();
    }
    final project = projects.first;
    final entries = project.timeEntries.toList();
    final entryDB = entries.firstWhereOrNull(
      (element) => element.id == entry.id,
    );
    if (entryDB == null) {
      return await _addTimeEntry(project, entry);
    }
    return await _updateTimeEntry(entryDB, entry);
  }

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

  bool _checkSameDateEntries(
      TimeEntryModel newEntry, List<TimeEntryRealmModel> currentEntries) {
    final entriesSameDate = currentEntries.where((element) {
      final elementDate = DateFormat('yyyy-MM-dd').format(element.startTime);
      final entryDate = DateFormat('yyyy-MM-dd').format(newEntry.startTime);
      if (elementDate == entryDate) {
        return true;
      }
      return false;
    });
    bool dateRangesOverlap = false;

    for (var element in entriesSameDate) {
      final entryDB = _convertEntryFromDB(element);
      dateRangesOverlap = newEntry.checkEntriesIntersect(entryDB);
      if (dateRangesOverlap) {
        break;
      }
    }
    return dateRangesOverlap;
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
