import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/interface/interface.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsScreenService {
  GroupsScreenService({required this.groupsRepository});
  final GroupsRepository groupsRepository;

  Future<List<GroupModel>> getGroups() async {
    return await groupsRepository.fetchGroups();
  }

  Future<List<ProjectModel>> getFavouriteProjects() async {
    return await groupsRepository.fetchFavouriteProjects();
  }

  Future<GroupsScreenModel> fetchGroupScreenData() async {
    // ToDo This is a usecase for GraphQL
    final groups = await groupsRepository.fetchGroups();
    final projects = await groupsRepository.fetchFavouriteProjects();
    return GroupsScreenModel(groups: groups, projects: projects);
  }

  Stream<GroupsScreenModel> watchData() async* {
    yield* Stream.fromFuture(fetchGroupScreenData());
    //ToDo get rid of this infinite loop
    while (true) {
      try {
        yield* Stream.fromFuture(fetchGroupScreenData());
      } catch (ex) {
        yield* Stream.error(ex);
      }
    }
  }
}

final groupsScreenServiceProvider = Provider<GroupsScreenService>((ref) {
  return GroupsScreenService(
    groupsRepository: ref.watch(deviceStorageGroupsRepositoryProvider),
  );
});
