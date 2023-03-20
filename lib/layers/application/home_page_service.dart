import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/layers/data/list_groups_repository.dart';
import 'package:my_time/layers/data/list_projects_repository.dart';
import 'package:my_time/layers/domain/home_page_dto.dart';
import 'package:my_time/layers/interface/data/projects_repository.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/interface/dto/project_dto.dart';

class HomePageService {
  HomePageService(
      {required this.groupsRepository, required this.projectsRespository});
  final ListGroupsRepository groupsRepository;
  final ProjectsRepository projectsRespository;

  Future<List<GroupDTO>> getGroups() async {
    await Future.delayed(const Duration(seconds: 2));
    return await groupsRepository.fetchGroups();
  }

  Future<List<ProjectDTO>> getFavouriteProjects() async {
    await Future.delayed(const Duration(seconds: 2));
    return await projectsRespository.fetchFavouriteProjects();
  }

  Future<HomePageDTO> fetchHomePageData() async {
    final groups = await groupsRepository.fetchGroups();
    final projects = await projectsRespository.fetchFavouriteProjects();
    return HomePageDTO(groups: groups, projects: projects);
  }

  Stream<HomePageDTO> watchData() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        yield* Stream.fromFuture(fetchHomePageData());
      } catch (ex) {
        yield* Stream.error(ex);
      }
    }
  }
}

final homePageServiceProvider = Provider<HomePageService>((ref) {
  return HomePageService(
    groupsRepository: ref.watch(groupsRepositoryProvider),
    projectsRespository: ref.watch(projectsRepositoryProvider),
  );
});
