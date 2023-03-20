import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/constants/test_groups.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/data/projects_repository.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class ListProjectsRepository implements ProjectsRepository {
  @override
  Future<List<ProjectDTO>> fetchFavouriteProjects() async {
    final result = await Future(() => kTestProjectsMap["favourites"]!);
    return result;
  }

  @override
  Future<bool> addProject(ProjectDTO project) async {
    //await Future.delayed(const Duration(seconds: 2));
    if (kTestProjectsMap.containsKey(project.parentId)) {
      kTestProjectsMap[project.parentId]!.add(project);
    } else {
      kTestProjectsMap[project.parentId] = [project];
    }
    return Future(() => true);
  }

  @override
  Future<List<ProjectDTO>> fetchProjectsByGroupId(String groupId) async {
    if (kTestProjectsMap.containsKey(groupId)) {
      return kTestProjectsMap[groupId]!;
    } else {
      return [];
    }
  }

  @override
  Stream<List<ProjectDTO>> watchProjectsByGroupId(String groupId) async* {
    yield await fetchProjectsByGroupId(groupId);
  }

  @override
  Future<bool> deleteProjects(List<ProjectDTO> projects) async {
    if (projects.isEmpty) {
      return true;
    }
    final key = projects.first.parentId;
    if (kTestProjectsMap.containsKey(key)) {
      kTestProjectsMap.remove(key);
    }
    return true;
  }

  final List<ProjectDTO> _projects = kTestProjects;

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

  List<ProjectDTO> getProjectsList() {
    return _projects;
  }

  ProjectDTO? getProject(String name) {
    return _projects.firstWhere((project) => project.name == name);
  }

  Future<List<ProjectDTO>> fetchProjectsList() async {
    await Future.delayed(const Duration(seconds: 2));
    //throw Exception("Failed to load");
    return Future.value(_projects);
  }

  // Stream<ProjectDTO?> watchProject(String name) {
  //   return watchProjectsByGroupId().map(
  //       (projects) => projects.firstWhere((project) => project.name == name));
  // }

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

final projectsRepositoryProvider = Provider<ListProjectsRepository>((ref) {
  return ListProjectsRepository();
});

final projectsByGroupIdStreamProvider =
    StreamProvider.autoDispose.family<List<ProjectDTO>, String>((ref, groupId) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.watchProjectsByGroupId(groupId);
});

final projectsListFutureProvider =
    FutureProvider.autoDispose<List<ProjectDTO>>((ref) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.fetchProjectsList();
});

// Use .family when you need to pass an argument
// final projectProvider =
//     StreamProvider.autoDispose.family<ProjectDTO?, String>((ref, id) {
//   final projectsRepository = ref.watch(projectsRepositoryProvider);
//   return projectsRepository.watchProject(id);
// });

// Use .family when you need to pass an argument
final projectTimeEntriesProvider = StreamProvider.autoDispose
    .family<List<List<TimeEntry>>?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.getAllEntriesGroupedByMonth(id);
});

// Use .family when you need to pass an argument
final projectTimeEntryProvider =
    StreamProvider.autoDispose.family<TimeEntry?, String>((ref, id) {
  final projectsRepository = ref.watch(projectsRepositoryProvider);
  return projectsRepository.getEntryById(id);
});
