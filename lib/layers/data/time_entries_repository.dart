import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/layers/domain/time_entry.dart';

class TimeEntriesRepository {
  Future<List<List<TimeEntryDTO>>> getAllProjectEntriesGroupedByMonth(
      String projectId) async {
    List<List<TimeEntryDTO>> groupedLists = [];
    if (!kTestTimeEntriesMap.containsKey(projectId)) {
      return groupedLists;
    }

    List<TimeEntryDTO> entries = kTestTimeEntriesMap[projectId]!;
    entries.sort(((a, b) => b.startTime.compareTo(a.startTime)));
    if (entries.isEmpty) {
      return groupedLists;
    }
    if (groupedLists.isEmpty) {
      groupedLists.add([]);
    }

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
    if (!kTestTimeEntriesMap.containsKey(entry.projectId)) {
      kTestTimeEntriesMap[entry.projectId] = [];
    }
    final index = kTestTimeEntriesMap[entry.projectId]!
        .indexWhere((element) => element.id == entry.id);
    if (index == -1) {
      kTestTimeEntriesMap[entry.projectId]!.add(entry);
    } else {
      kTestTimeEntriesMap[entry.projectId]![index] = entry;
    }
    return true;
  }

  Future<TimeEntryDTO?> getEntryById(String id) async {
    TimeEntryDTO? entry;
    kTestTimeEntriesMap.forEach((key, value) {
      entry = value.firstWhereOrNull((entry) => entry.id == id);
      if (entry != null) {
        return;
      }
    });
    return entry;
  }
}

final timeEntriesRepositoryProvider = Provider<TimeEntriesRepository>((ref) {
  return TimeEntriesRepository();
});
