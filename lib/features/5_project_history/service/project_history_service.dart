import 'package:my_time/features/5_project_history/5_project_history.dart';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';

class ProjectHistoryService {
  final ProjectHistoryRepository projectHistoryRepository;
  ProjectHistoryService(this.projectHistoryRepository);

  Stream<List<List<TimeEntryModel>>> streamProjectEntriesGroupedByMonth(
      String projectId) {
    return projectHistoryRepository
        .streamProjectEntriesGroupedByMonth(projectId)
        .map((entries) {
      List<List<TimeEntryModel>> groupedLists = [];

      List<TimeEntryModel> timeEntryModels = entries;

      if (timeEntryModels.isEmpty) {
        return groupedLists;
      }
      if (groupedLists.isEmpty) {
        groupedLists.add([]);
      }

      timeEntryModels.sort(((a, b) => b.startTime.compareTo(a.startTime)));
      DateTime currentYearAndMonth =
          timeEntryModels.first.startTime.yearAndMonth();
      int index = 0;

      for (final entry in timeEntryModels) {
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
    });
  }
}

// Use .family when you need to pass an argument
final projectHistoryProvider = StreamProvider.autoDispose
    .family<List<List<TimeEntryModel>>?, String>((ref, projectId) {
// get the [KeepAliveLink]
  final link = ref.keepAlive();
  // a timer to be used by the callbacks below
  Timer? timer;
  // An object from package:dio that allows cancelling http requests
  final cancelToken = CancelToken();
  // When the provider is destroyed, cancel the http request and the timer
  ref.onDispose(() {
    timer?.cancel();
    cancelToken.cancel();
  });
  // When the last listener is removed, start a timer to dispose the cached data
  ref.onCancel(() {
    // start a 30 second timer
    timer = Timer(const Duration(seconds: 120), () {
      // dispose on timeout
      link.close();
    });
  });
  // If the provider is listened again after it was paused, cancel the timer
  ref.onResume(() {
    timer?.cancel();
  });
  ProjectHistoryService service =
      ProjectHistoryService(ref.read(projectHistoryRepositoryProvider));

  return service.streamProjectEntriesGroupedByMonth(projectId);
});
