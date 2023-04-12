import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/group.dart';
import 'package:my_time/layers/interface/dto/project.dart';
import 'package:my_time/layers/interface/dto/time_entry.dart';
import 'package:realm/realm.dart';

class TimeEntriesRepository {
  final Realm realm;
  TimeEntriesRepository(this.realm);

  Future<List<List<TimeEntryDTO>>> getAllProjectEntriesGroupedByMonth(
      String projectId) async {
    List<List<TimeEntryDTO>> groupedLists = [];
    final project = realm.all<Project>().query("id == '$projectId'").first;
    final entriesDB = project.timeEntries.toList();
    List<TimeEntryDTO> entries = [];
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

  Future<bool> addTimeEntry(Project project, TimeEntryDTO entry) async {
    if (_checkSameDateEntries(entry, project.timeEntries)) {
      throw Exception(
          "Given Timerange is overlapping with an existing Timerange!");
    }
    await realm.writeAsync(() {
      final newEntryDB = TimeEntry(
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

  Future<bool> updateTimeEntry(
      TimeEntry entry, TimeEntryDTO updatedEntry) async {
    await realm.writeAsync(() {
      entry.startTime = updatedEntry.startTime;
      entry.endTime = updatedEntry.endTime;
      entry.totalTimeStr = updatedEntry.totalTime.toString();
      entry.breakTimeStr = updatedEntry.breakTime.toString();
      entry.description = updatedEntry.description;
    });
    return true;
  }

  Future<bool> saveTimeEntry(TimeEntryDTO entry) async {
    final project =
        realm.all<Project>().query("id == '${entry.projectId}'").first;
    final entries = project.timeEntries.toList();
    final entryDB = entries.firstWhereOrNull(
      (element) => element.id == entry.id,
    );
    if (entryDB == null) {
      return await addTimeEntry(project, entry);
    }
    return await updateTimeEntry(entryDB, entry);
  }

  Future<bool> deleteEntry(TimeEntryDTO entry) async {
    final entryDB = realm.all<TimeEntry>().query("id == '${entry.id}'").first;
    await realm.writeAsync(() {
      realm.delete<TimeEntry>(entryDB);
    });
    return true;
  }

  bool _checkSameDateEntries(
      TimeEntryDTO newEntry, List<TimeEntry> currentEntries) {
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

  Future<TimeEntryDTO> getEntryById(String id) async {
    var entries = realm.all<TimeEntry>().query("id == '$id'");
    if (entries.isEmpty) {
      throw Exception("No Entry with given ID found!");
    }
    return _convertEntryFromDB(entries.first);
  }

  TimeEntryDTO _convertEntryFromDB(TimeEntry entryDB) {
    return TimeEntryDTO.factory(
        id: entryDB.id,
        projectId: entryDB.projectId,
        startTime: entryDB.startTime.toLocal(),
        endTime: entryDB.endTime.toLocal(),
        totalTime: DurationExtension.parseDuration(entryDB.totalTimeStr),
        breakTime: DurationExtension.parseDuration(entryDB.breakTimeStr),
        description: entryDB.description);
  }
}

final timeEntriesRepositoryProvider = Provider<TimeEntriesRepository>((ref) {
  final config =
      Configuration.local([Group.schema, Project.schema, TimeEntry.schema]);
  return TimeEntriesRepository(Realm(config));
});
