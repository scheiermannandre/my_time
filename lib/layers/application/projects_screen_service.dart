import 'dart:async';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/data/time_entries_repository.dart';
import 'package:my_time/layers/domain/time_entry.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ProjectsScreenService {
  ProjectsScreenService({required this.ref});

  final ProviderRef ref;
  Stream<List<List<TimeEntryDTO>>?> watchAllEntriesGroupedByMonth(
      String projectId) async* {
    final timeEntriesRepository = ref.read(timeEntriesRepositoryProvider);
    yield* Stream.fromFuture(
        timeEntriesRepository.getAllProjectEntriesGroupedByMonth(projectId));
  }

  Future<bool> deleteProject(ProjectDTO project) async {
    return await ref.read(projectsRepositoryProvider).deleteProject(project);
  }
}

final projectsScreenServiceProvider = Provider<ProjectsScreenService>((ref) {
  return ProjectsScreenService(ref: ref);
});
