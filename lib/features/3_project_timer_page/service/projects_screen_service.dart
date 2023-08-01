import 'dart:async';

import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Service for the ProjectsScreen.
class ProjectsScreenService {
  /// Constructor for the [ProjectsScreenService].
  ProjectsScreenService({required this.ref});

  /// The provider reference.
  final ProviderRef<dynamic> ref;

  /// Will delete the project.
  Future<bool> deleteProject(String projectId) async {
    return ref.read(projectsRepositoryProvider).deleteProject(projectId);
  }
}

/// Provides the [ProjectsScreenService].
final projectsScreenServiceProvider = Provider<ProjectsScreenService>((ref) {
  return ProjectsScreenService(ref: ref);
});
