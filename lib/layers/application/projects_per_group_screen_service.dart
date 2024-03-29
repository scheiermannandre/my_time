import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/layers/data/list_groups_repository.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/interface/data/projects_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/group_with_projects_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class ProjectsPerGroupScreenService {
  ProjectsPerGroupScreenService({
    required this.groupsRepository,
    required this.projectsRespository,
  });

  final ListGroupsRepository groupsRepository;
  final ProjectsRepository projectsRespository;

  Future<GroupDTO> fetchGroup(String groupId) async {
    GroupDTO? group = await groupsRepository.fetchGroup(groupId);
    return group!;
  }

  Future<List<ProjectDTO>> fetchProjectsByGroupId(String groupId) async {
    return await projectsRespository.fetchProjectsByGroupId(groupId);
  }

  Future<GroupWithProjectsDTO> fetchGroupWithProjectsDTO(String groupId) async {
    final group = await groupsRepository.fetchGroup(groupId) as GroupDTO;
    final projects = await projectsRespository.fetchProjectsByGroupId(groupId);
    return GroupWithProjectsDTO(group: group, projects: projects);
  }

  Stream<GroupWithProjectsDTO> watchData(String groupId) async* {
    try {
      yield* Stream.fromFuture(fetchGroupWithProjectsDTO(groupId));
    } catch (ex) {
      yield* Stream.error(ex);
    }
  }

  Future<bool> deleteGroup(GroupWithProjectsDTO dto) async {
    bool deleteGroupResult = await groupsRepository.deleteGroup(dto.group.id);
    return deleteGroupResult;
  }
}

final projectsPerGroupScreenServiceProvider =
    Provider<ProjectsPerGroupScreenService>((ref) {
  return ProjectsPerGroupScreenService(
    groupsRepository: ref.watch(groupsRepositoryProvider),
    projectsRespository: ref.watch(projectsRepositoryProvider),
  );
});
