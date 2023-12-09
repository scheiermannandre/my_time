import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/project_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_service.g.dart';

/// Service class for managing projects.
class ProjectService {
  /// Constructor that takes a [ref] parameter.
  ProjectService({required this.ref});

  /// Reference to Riverpod for dependency injection.
  final Ref ref;

  /// Adds a new project with the given [project] settings.
  Future<void> addProject(
    String groupId,
    String projectId,
    Map<String, dynamic> project,
  ) async {
    return ref
        .read(projectRepositoryImplProvider)
        .addProject(groupId, projectId, project);
  }
}

/// Riverpod provider for the [ProjectService] class.
@riverpod
ProjectService projectService(ProjectServiceRef ref) {
  return ProjectService(ref: ref);
}
