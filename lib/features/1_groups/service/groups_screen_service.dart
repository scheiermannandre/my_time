import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:rxdart/rxdart.dart';

/// Service for the GroupsScreen containing specific logic.
class GroupsScreenService {
  /// Creates a [GroupsScreenService].
  GroupsScreenService({required this.groupsRepository});

  /// The [GroupsRepository] instance, which is the interface to the database.
  final GroupsRepository groupsRepository;

  /// Streams the Groups and Favourite Projects from the database and combines
  /// them into a new single stream with the type [GroupsScreenModel].
  Stream<GroupsScreenModel> streamGroupsScreenModel() async* {
    final groupsStream = groupsRepository.streamGroups();
    final favouriteProjectsStream = groupsRepository.streamFavouriteProjects();

    final groupScreenModelStream = CombineLatestStream.combine2(
      groupsStream,
      favouriteProjectsStream,
      (groups, favouriteProjects) => GroupsScreenModel(
        groups: groups,
        favouriteProjects: favouriteProjects,
      ),
    );
    yield* groupScreenModelStream;
  }
}

/// Provider that delivers the [GroupsScreenService].
final groupsScreenServiceProvider = Provider<GroupsScreenService>((ref) {
  return GroupsScreenService(
    groupsRepository: ref.watch(deviceStorageGroupsRepositoryProvider),
  );
});
