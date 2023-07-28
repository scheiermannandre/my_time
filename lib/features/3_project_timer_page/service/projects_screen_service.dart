import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ProjectsScreenService {
  ProjectsScreenService({required this.ref});

  final ProviderRef ref;

  Future<bool> deleteProject(String projectId) async {
    return await ref.read(projectsRepositoryProvider).deleteProject(projectId);
  }
}

final projectsScreenServiceProvider = Provider<ProjectsScreenService>((ref) {
  return ProjectsScreenService(ref: ref);
});
