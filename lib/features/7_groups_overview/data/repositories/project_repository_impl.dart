import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/features/7_groups_overview/data/datasources/firestore_projects_data_source.dart';
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
    String groupId,
    String projectId,
    Map<String, dynamic> project,
  ) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    return ref
        .read(projectsFirestoreDataSourceProvider)
        .addProject(uid, groupId, projectId, project);
  }
}

/// Riverpod provider for [ProjectRepositoryImpl].
@riverpod
ProjectRepositoryImpl projectRepositoryImpl(ProjectRepositoryImplRef ref) {
  return ProjectRepositoryImpl(ref: ref);
}
