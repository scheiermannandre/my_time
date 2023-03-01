import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/constants/test_projects.dart';
import 'package:my_time/features/projects_groups/domain/project.dart';
import 'package:my_time/features/projects_groups/domain/time_entry.dart';

class FakeProjectsRepository {
  final List<Project> _projects = kTestProjects;

  List<TimeEntry> buildTimeEntries() {
    List<TimeEntry> entries = [];
    DateTime end = DateTime.now();
    DateTime start = end.subtract(const Duration(hours: 8));
    Duration total = end.difference(start);
    for (int i = 0; i < 100; i++) {
      TimeEntry entry = TimeEntry(i.toString(), start, end, total);
      entries.add(entry);
      end = end.subtract(const Duration(days: 1));
      var rng = Random();
      var tmp = rng.nextInt(3) + 2;
      start = end.subtract(Duration(hours: tmp));
      total = end.difference(start);
    }
    return entries;
  }

  List<Project> getProjectsList() {
    return _projects;
  }

  Project? getProject(String name) {
    return _projects.firstWhere((project) => project.name == name);
  }

  Future<List<Project>> fetchProjectsList() async {
    await Future.delayed(const Duration(seconds: 2));
    //throw Exception("Failed to load");
    return Future.value(_projects);
  }

  Stream<List<Project>> watchProjectsList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _projects;
    //return Stream.value(_projects);
  }

  Stream<Project?> watchProject(String name) {
    return watchProjectsList().map(
        (projects) => projects.firstWhere((project) => project.name == name));
  }

  Stream<TimeEntry?> getEntryById(String id) async* {
    await Future.delayed(const Duration(seconds: 2));
    yield buildTimeEntries().firstWhereOrNull((element) => element.id == id);
  }

  Stream<List<List<TimeEntry>>?> getAllEntriesGroupedByMonth(
      String name) async* {
    await Future.delayed(const Duration(seconds: 2));
    // buildTimeEntries().groupBy((m) => m.startTime.month);
    //Map<String, List<TimeEntry>> groupedEntries = {};
    List<List<TimeEntry>> groupedLists = [];
    List<TimeEntry> entries = buildTimeEntries();
    entries.sort(((a, b) => b.startTime.compareTo(a.startTime)));
    if (entries.isEmpty) {
      yield groupedLists;
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

      // String key = entry.startTime.toMonthAndYearString();
      // if (!groupedEntries.containsKey(key)) {
      //   groupedEntries[key] = <TimeEntry>[];
      // }
      // groupedEntries[key]!.add(entry);
    }
    yield groupedLists;
  }
}

int mySortComparison(TimeEntry a, TimeEntry b) {
  final propertyA = a.startTime;
  final propertyB = b.startTime;
  if (propertyA.microsecondsSinceEpoch < propertyB.microsecondsSinceEpoch) {
    return -1;
  } else if (propertyA.microsecondsSinceEpoch >
      propertyB.microsecondsSinceEpoch) {
    return 1;
  } else {
    return 0;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

final projectsRepositoryProvider = Provider<FakeProjectsRepository>((ref) {
  return FakeProjectsRepository();
});

final projectsListStreamProvider =
    StreamProvider.autoDispose<List<Project>>((ref) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.watchProjectsList();
});

final projectsListFutureProvider =
    FutureProvider.autoDispose<List<Project>>((ref) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.fetchProjectsList();
});

// Use .family when you need to pass an argument
final projectProvider =
    StreamProvider.autoDispose.family<Project?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.watchProject(id);
});

// Use .family when you need to pass an argument
final projectTimeEntriesProvider = StreamProvider.autoDispose
    .family<List<List<TimeEntry>>?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.getAllEntriesGroupedByMonth(id);
});

// Use .family when you need to pass an argument
final projectTimeEntryProvider = StreamProvider.autoDispose
    .family<TimeEntry?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.getEntryById(id);
});
