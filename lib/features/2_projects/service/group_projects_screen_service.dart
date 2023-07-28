import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsPerGroupScreenService {
  ProjectsPerGroupScreenService({
    //required this.groupsRepository,
    required this.projectsRespository,
  });

  //final RealmDbGroupsRepository groupsRepository;
  final ProjectsRepository projectsRespository;

  Future<GroupModel> fetchGroup(String groupId) async {
    GroupModel? group = await projectsRespository.fetchGroup(groupId);
    return group!;
  }

  Future<List<ProjectModel>> fetchProjectsByGroupId(String groupId) async {
    return await projectsRespository.fetchProjectsByGroupId(groupId);
  }

  Future<GroupProjectsPageModel> fetchGroupWithProjectsDTO(
      String groupId) async {
    final group = await projectsRespository.fetchGroup(groupId) as GroupModel;
    final projects = await projectsRespository.fetchProjectsByGroupId(groupId);
    return GroupProjectsPageModel(group: group, projects: projects);
  }

  Stream<GroupProjectsPageModel> watchData(String groupId) async* {
    try {
      yield* Stream.fromFuture(fetchGroupWithProjectsDTO(groupId));
    } catch (ex) {
      yield* Stream.error(ex);
    }
  }

  Future<bool> deleteGroup(GroupProjectsPageModel dto) async {
    bool deleteGroupResult =
        await projectsRespository.deleteGroup(dto.group.id);
    return deleteGroupResult;
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
