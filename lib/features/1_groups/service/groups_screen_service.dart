import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class GroupsScreenService {
  GroupsScreenService({required this.groupsRepository});
  final GroupsRepository groupsRepository;

  Stream<GroupsScreenModel> streamGroupsScreenModel() async* {
    final groupsStream = groupsRepository.streamGroups();
    final favouriteProjectsStream = groupsRepository.streamFavouriteProjects();

    var groupScreenModelStream = CombineLatestStream([
      groupsStream,
      favouriteProjectsStream,
    ], mapToGroupScreenModel);
    yield* groupScreenModelStream;
  }

  GroupsScreenModel mapToGroupScreenModel(List<List<Object>> values) {
    final groups = values[0] as List<GroupModel>;
    final projects = values[1] as List<ProjectModel>;
    return GroupsScreenModel(groups: groups, projects: projects);
  }
}

final groupsScreenServiceProvider = Provider<GroupsScreenService>((ref) {
  return GroupsScreenService(
    groupsRepository: ref.watch(deviceStorageGroupsRepositoryProvider),
  );
});
