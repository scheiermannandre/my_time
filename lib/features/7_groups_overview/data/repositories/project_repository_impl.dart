import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firestore_projects_data_source.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_model.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/repositories/project_repository.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_repository_impl.g.dart';

/// Implementation of the [ProjectRepository] interface.
class ProjectRepositoryImpl extends ProjectRepository {
  /// Constructor for [ProjectRepositoryImpl].
  ProjectRepositoryImpl({required this.ref});

  /// Reference to Riverpod.
  final Ref ref;

  /// Adds a new project with settings using the provided [project].
  @override
  Future<void> addProject(
    ProjectEntity project,
  ) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(projectsFirestoreDataSourceProvider)
        .addProject(uid, ProjectModel.fromEntity(project));
  }

  @override
  Future<ProjectEntity> fetchProject(
    String groupId,
    String projectId,
  ) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(projectsFirestoreDataSourceProvider)
        .fetchProject(uid, groupId, projectId)
        .then((value) => value.toEntity());
  }
}

/// Riverpod provider for [ProjectRepositoryImpl].
@riverpod
ProjectRepositoryImpl projectRepositoryImpl(ProjectRepositoryImplRef ref) {
  return ProjectRepositoryImpl(ref: ref);
}
