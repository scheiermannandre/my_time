import 'package:my_time/features/1_groups/1_groups.dart';

/// Base class for the GroupsRepository.
abstract class GroupsRepository {
  /// Method that will add a new group to the database.
  Future<bool> addGroup(GroupModel group);

  /// Method that will stream the groups from the database.
  Stream<List<GroupModel>> streamGroups();

  /// Method that will stream the favourite projects from the database.
  Stream<List<ProjectModel>> streamFavouriteProjects();
}
