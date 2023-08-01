import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

/// Service for the ProjectsPerGroupScreen.
class GroupProjectsScreenService {
  /// Creates a [GroupProjectsScreenService].
  GroupProjectsScreenService({
    required this.projectsRespository,
  });

  /// The [ProjectsRepository] used to access the database.
  final ProjectsRepository projectsRespository;

  /// Streams a [GroupProjectsPageModel] for the given [groupId].
  Stream<GroupProjectsPageModel> streamGroupProjectsPageModel(
    String groupId,
  ) async* {
    final group = await projectsRespository.fetchGroup(groupId);
    if (group == null) {
      // ignore: only_throw_errors
      throw const CustomAppException.groupNotFound();
    } else {
      yield* projectsRespository.streamProjectsByGroupId(groupId).map(
            (projects) =>
                GroupProjectsPageModel(group: group, projects: projects),
          );
    }
  }

  /// Deletes the Group with the given [groupId].
  Future<bool> deleteGroup(String groupId) async =>
      projectsRespository.deleteGroup(groupId);
}

/// Provides a [GroupProjectsScreenService].
final groupProjectsScreenServiceProvider = Provider<GroupProjectsScreenService>(
  (ref) {
    return GroupProjectsScreenService(
      projectsRespository: ref.watch(deviceStorageProjectsRepositoryProvider),
    );
  },
);
