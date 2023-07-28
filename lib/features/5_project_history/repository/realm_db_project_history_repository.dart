import 'package:my_time/common/common.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:realm/realm.dart';

class RealmDbProjectHistoryRepository implements ProjectHistoryRepository {
  final Realm realm;
  RealmDbProjectHistoryRepository(this.realm);

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
  Future<List<List<TimeEntryModel>>> getAllProjectEntriesGroupedByMonth(
      String projectId) async {
    List<List<TimeEntryModel>> groupedLists = [];
    final project =
        realm.all<ProjectRealmModel>().query("id == '$projectId'").first;
    final entriesDB = project.timeEntries.toList();
    List<TimeEntryModel> entries = [];
    for (var element in entriesDB) {
      entries.add(_convertEntryFromDB(element));
    }
    if (entries.isEmpty) {
      return groupedLists;
    }
    if (groupedLists.isEmpty) {
      groupedLists.add([]);
    }

    entries.sort(((a, b) => b.startTime.compareTo(a.startTime)));
    DateTime currentYearAndMonth = entries.first.startTime.yearAndMonth();
    int index = 0;
    for (var entry in entries) {
      DateTime entryYearAndMonth = entry.startTime.yearAndMonth();
      if (entryYearAndMonth == currentYearAndMonth) {
        groupedLists[index].add(entry);
      } else {
        index++;
        groupedLists.add([]);
        groupedLists[index].add(entry);
      }
      currentYearAndMonth = entryYearAndMonth;
    }
    return groupedLists;
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

final projectHistoryRepositoryProvider =
    Provider<RealmDbProjectHistoryRepository>((ref) {
  final config = Configuration.local(
      [ProjectRealmModel.schema, TimeEntryRealmModel.schema]);
  return RealmDbProjectHistoryRepository(Realm(config));
});
