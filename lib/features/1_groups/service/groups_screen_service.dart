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

    final groupScreenModelStream = CombineLatestStream.combine2(
      groupsStream,
      favouriteProjectsStream,
      (groups, favouriteProjects) =>
          GroupsScreenModel(groups: groups, projects: favouriteProjects),
    );
    yield* groupScreenModelStream;
  }
}

final groupsScreenServiceProvider = Provider<GroupsScreenService>((ref) {
  return GroupsScreenService(
    groupsRepository: ref.watch(deviceStorageGroupsRepositoryProvider),
  );
});
