import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/project_repository_impl.dart';
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
  Future<void> addProject(
    ProjectEntity project,
  ) async {
    return ref.read(projectRepositoryImplProvider).addProject(project);
  }

  /// Updates a project with the given [project] settings.
  Future<void> updateProject(
    ProjectEntity project,
  ) async {
    return ref.read(projectRepositoryImplProvider).updateProject(project);
  }

  /// Fetches a project with the specified [groupId] and [projectId].
  Future<ProjectEntity> fetchProject(
    String groupId,
    String projectId,
  ) {
    return ref
        .read(projectRepositoryImplProvider)
        .fetchProject(groupId, projectId);
  }

  /// Streams a project with the specified [groupId] and [projectId].
  Stream<ProjectEntity> streamProject(
    String groupId,
    String projectId,
  ) {
    return ref
        .read(projectRepositoryImplProvider)
        .streamProject(groupId, projectId);
  }
}

/// Riverpod provider for the [ProjectService] class.
@riverpod
ProjectService projectService(ProjectServiceRef ref) {
  return ProjectService(ref: ref);
}

/// Riverpod provider for fetching a Project class.
@riverpod
FutureOr<ProjectEntity> fetchProject(
  Ref ref, {
  required String groupId,
  required String projectId,
}) {
  return ref.read(projectServiceProvider).fetchProject(groupId, projectId);
}

/// Riverpod provider for streaming a Project class.
@riverpod
Stream<ProjectEntity> streamProject(
  StreamProjectRef ref, {
  required String groupId,
  required String projectId,
}) {
  return ref.read(projectServiceProvider).streamProject(groupId, projectId);
}
