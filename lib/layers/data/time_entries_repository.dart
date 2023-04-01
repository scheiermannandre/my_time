import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final test = realm.all<TimeEntry>().toList();

    List<TimeEntryDTO> entries = [];
    for (var element in entriesDB) {
      entries.add(convertEntryFromDB(element));
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

  Future<bool> saveTimeEntry(TimeEntryDTO entry) async {
    final project =
        realm.all<Project>().query("id == '${entry.projectId}'").first;

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
      final entryDB = project.timeEntries
          .firstWhereOrNull((element) => element.id == newEntryDB.id);

      if (entryDB == null) {
        project.timeEntries.add(newEntryDB);
      } else {
        entryDB.startTime = newEntryDB.startTime;
        entryDB.endTime = newEntryDB.endTime;
        entryDB.totalTimeStr = newEntryDB.totalTimeStr;
        entryDB.breakTimeStr = newEntryDB.breakTimeStr;
        entryDB.description = newEntryDB.description;
      }
    });
    return true;
  }

  Future<TimeEntryDTO?> getEntryById(String id) async {
    var entries = realm.all<TimeEntry>().query("id == '$id'");
    if (entries.isEmpty) {
      return null;
    }
    return convertEntryFromDB(entries.first);
  }

  TimeEntryDTO convertEntryFromDB(TimeEntry entryDB) {
    return TimeEntryDTO.factory(
        id: entryDB.id,
        projectId: entryDB.projectId,
        startTime: entryDB.startTime,
        endTime: entryDB.endTime,
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
