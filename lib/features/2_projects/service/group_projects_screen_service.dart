import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsPerGroupScreenService {
  ProjectsPerGroupScreenService({
    required this.projectsRespository,
  });

  final ProjectsRepository projectsRespository;

  // Future<List<ProjectModel>> fetchProjectsByGroupId(String groupId) async {
  //   return await projectsRespository.fetchProjectsByGroupId(groupId);
  // }

  // Future<GroupProjectsPageModel> fetchGroupWithProjectsDTO(
  //     String groupId) async {
  //   final group = await projectsRespository.fetchGroup(groupId) as GroupModel;
  //   final projects = await projectsRespository.fetchProjectsByGroupId(groupId);
  //   return GroupProjectsPageModel(group: group, projects: projects);
  // }

  Stream<GroupProjectsPageModel> streamGroupProjectsPageModel(
      String groupId) async* {
    final group = await projectsRespository.fetchGroup(groupId) as GroupModel;

    yield* projectsRespository.streamProjectsByGroupId(groupId).map(
          (projects) =>
              GroupProjectsPageModel(group: group, projects: projects),
        );
  }

  Future<bool> deleteGroup(String groupId) async {
    return await projectsRespository.deleteGroup(groupId);
  }
}

final groupProjectsScreenServiceProvider =
    Provider<ProjectsPerGroupScreenService>(
  (ref) {
    return ProjectsPerGroupScreenService(
      projectsRespository: ref.watch(deviceStorageProjectsRepositoryProvider),
    );
  },
);
