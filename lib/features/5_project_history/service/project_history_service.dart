import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';

/// Service for the project history feature.
class ProjectHistoryService {
  /// Constructor for the [ProjectHistoryService].
  ProjectHistoryService(this.projectHistoryRepository);

  /// The [ProjectHistoryRepository] instance.
  final ProjectHistoryRepository projectHistoryRepository;

  /// Will Stream a list of TimeEntry grouped by month.
  Stream<List<List<TimeEntryModel>>> streamProjectEntriesGroupedByMonth(
    String projectId,
  ) {
    return projectHistoryRepository
        .streamProjectEntries(projectId)
        .map((entries) {
      final groupedLists = <List<TimeEntryModel>>[];

      final timeEntryModels = entries;

      if (timeEntryModels.isEmpty) {
        return groupedLists;
      }
      if (groupedLists.isEmpty) {
        groupedLists.add([]);
      }

      timeEntryModels.sort((a, b) => b.startTime.compareTo(a.startTime));
      var currentYearAndMonth = timeEntryModels.first.startTime.yearAndMonth();
      var index = 0;

      for (final entry in timeEntryModels) {
        final entryYearAndMonth = entry.startTime.yearAndMonth();
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

/// Provides the [ProjectHistoryService].
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
  ref
    ..onDispose(() {
      timer?.cancel();
      cancelToken.cancel();
    })
    // When the last listener is removed,
    //start a timer to dispose the cached data
    ..onCancel(() {
      // start a 30 second timer
      timer = Timer(const Duration(seconds: 120), link.close);
    })
    // If the provider is listened again after it was paused, cancel the timer
    ..onResume(() {
      timer?.cancel();
    });
  final service =
      ProjectHistoryService(ref.read(projectHistoryRepositoryProvider));

  return service.streamProjectEntriesGroupedByMonth(projectId);
});
