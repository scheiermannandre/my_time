import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/group_repository_impl.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_service.g.dart';

/// Service class for managing projects.
class ProjectService {
  /// Constructor that takes a [ref] parameter.
  ProjectService({required this.ref});

  /// Reference to Riverpod for dependency injection.
  final Ref ref;

  /// Adds a new project with the given [project] settings.
  Future<void> addProject(ProjectWithSettingsEntity project) {
    return ref.read(groupRepositoryImplProvider).addProject(project);
  }
}

/// Riverpod provider for the [ProjectService] class.
@riverpod
ProjectService projectService(ProjectServiceRef ref) {
  return ProjectService(ref: ref);
}
